package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"
	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider/types"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/golang-jwt/jwt/v5"
	"github.com/mauri-codes/go-modules/aws/dynamo"
	"github.com/mauri-codes/go-modules/utils"
)

const (
	USER_CREATED = "USER_CREATED"
	USER_ADDED   = "USER_ADDED"
	NO_ACTION    = "NO_ACTION"
)

type UserAccountItem struct {
	PK string `dynamodbav:"pk"`
	SK string `dynamodbav:"sk"`
	AccoutData
}

type RegisterAccountEvent struct {
	AccessToken string
	AccoutData
}

type AccoutData struct {
	AccountId       string
	EnvironmentName string
	DeployerRole    string
	TesterRole      string
	Region          string
	Region2         string
}

type RegisterAccountResponse struct {
	Success       bool
	ErrorResponse *string
}

type CustomClaims struct {
	Username string `json:"name"`
	jwt.RegisteredClaims
}

var dbClient *dynamodb.Client
var cognitoClient *cognitoidentityprovider.Client
var appTable string

func init() {
	appTable = os.Getenv("APP_TABLE")
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("Failed to load configuration, %v", err)
	}
	dbClient = dynamodb.NewFromConfig(cfg)
	cognitoClient = cognitoidentityprovider.NewFromConfig(cfg)
}

func main() {
	lambda.Start(handleRequest)
}

func handleRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var event RegisterAccountEvent
	idToken := strings.Split(request.Headers["Authorization"], " ")[1]
	if err := json.Unmarshal([]byte(request.Body), &event); err != nil {
		return utils.Error500(utils.ResponseInput{
			Message: fmt.Sprintf("Failed to unmarshal event: %v", err),
		})
	}

	claims := &CustomClaims{}
	_, _, err := new(jwt.Parser).ParseUnverified(idToken, claims)
	if err != nil {
		return utils.Error500(utils.ResponseInput{
			Message: fmt.Sprintf("Failed to process token: %v", err),
		})
	}

	PK := "user_" + claims.Username + "#environments"
	table := dynamo.NewTable(appTable, "pk", "sk", dbClient)

	if err := CheckPreviouslyCreatedEnvs(table, PK, event.EnvironmentName); err != nil {
		return utils.Error400(utils.ResponseInput{
			Message: fmt.Sprintf("Previously Created Envs Check Failed: %v", err),
		})
	}

	if err = UpdateDynamoTable(event, table, PK); err != nil {
		return utils.Error500(utils.ResponseInput{
			Message: fmt.Sprintf("Failed to save user Environment in DB: %v", err),
		})
	}

	if err = UpdateCognitoAttribute(event.EnvironmentName, event.AccessToken); err != nil {
		return utils.Error500(utils.ResponseInput{
			Message: fmt.Sprintf("Failed to save user Environment in Identity: %v", err),
		})
	}

	return utils.SuccessResponse(utils.ResponseInput{
		Message: "Environment saved successfully",
	})
}

func CheckPreviouslyCreatedEnvs(table *dynamo.Table, PK string, envName string) error {
	queryAction := dynamo.NewQuery[UserAccountItem](PK, "", "")
	envs, queryErr := dynamo.Query(table, queryAction)
	if queryErr != nil {
		return queryErr
	}
	if len(envs) >= 3 {
		return errors.New("no more than 3 environments allowed")
	}
	for _, item := range envs {
		if item.EnvironmentName == envName {
			return fmt.Errorf("environment %s already in use", item.EnvironmentName)
		}
	}
	return nil
}

func UpdateDynamoTable(event RegisterAccountEvent, table *dynamo.Table, PK string) error {
	SK := fmt.Sprintf("ws-%s", event.EnvironmentName)
	utils.Pr(SK)
	putEnvAction := dynamo.NewPutItem(PK, SK, UserAccountItem{
		PK:         PK,
		SK:         SK,
		AccoutData: event.AccoutData,
	})
	return dynamo.PutItem(table, putEnvAction)
}

func UpdateCognitoAttribute(envName string, accessToken string) error {
	getUserInput := &cognitoidentityprovider.GetUserInput{
		AccessToken: &accessToken,
	}
	userData, userInputErr := cognitoClient.GetUser(context.TODO(), getUserInput)

	if userInputErr != nil {
		return userInputErr
	}

	envsKeyName := "custom:env"
	emptyEnv := "NONE"
	var envsValue string
	userEnvs := ""
	for _, Attributes := range userData.UserAttributes {
		if *Attributes.Name == envsKeyName {
			if *Attributes.Value != emptyEnv {
				userEnvs = *Attributes.Value
			}
		}
	}
	if userEnvs == "" {
		envsValue = envName
		keyName := "custom:defaultEnv"
		updateDefaultAttributeInput := &cognitoidentityprovider.UpdateUserAttributesInput{
			AccessToken: &accessToken,
			UserAttributes: []types.AttributeType{
				{
					Name:  &keyName,
					Value: &envsValue,
				},
			},
		}
		_, err := cognitoClient.UpdateUserAttributes(context.TODO(), updateDefaultAttributeInput)
		if err != nil {
			return err
		}
	} else {
		envsValue = fmt.Sprintf("%s,%s", userEnvs, envName)
	}
	upDateAttributeInput := &cognitoidentityprovider.UpdateUserAttributesInput{
		AccessToken: &accessToken,
		UserAttributes: []types.AttributeType{
			{
				Name:  &envsKeyName,
				Value: &envsValue,
			},
		},
	}
	_, err := cognitoClient.UpdateUserAttributes(context.TODO(), upDateAttributeInput)
	return err
}
