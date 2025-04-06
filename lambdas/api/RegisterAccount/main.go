package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"

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
	IdToken     string
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
	Envs     string `json:"custom:env"`
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
	if err := json.Unmarshal([]byte(request.Body), &event); err != nil {
		return utils.Error500(utils.ResponseInput{
			Message: fmt.Sprintf("Failed to unmarshal event: %v", err),
		}), err
	}
	utils.Pr("---event---")
	utils.Pr(event)

	claims := &CustomClaims{}
	_, _, err := new(jwt.Parser).ParseUnverified(event.IdToken, claims)
	if err != nil {
		return utils.Error500(utils.ResponseInput{
			Message: fmt.Sprintf("Failed to process token: %v", err),
		}), err
	}

	fmt.Println(claims.Username)
	PK := "user_" + claims.Username + "#environments"
	table := dynamo.NewTable(appTable, "pk", "sk", dbClient)

	if data, err := GetDBEnvironments(table, PK); err != nil {
		return utils.Error400(utils.ResponseInput{
			Message: fmt.Sprintf("Failed to verify current user's environments: %v", err),
		}), err
	} else {
		utils.Pr(data)
		if len(data) >= 3 {
			return utils.Error400(utils.ResponseInput{
				Message: "No more than 3 environments allowed",
			}), err
		}
	}

	if err = UpdateDynamoTable(event, table, PK); err != nil {
		return utils.Error500(utils.ResponseInput{
			Message: fmt.Sprintf("Failed to save user Environment in DB: %v", err),
		}), err
	}

	if err = UpdateCognitoAttribute(claims.Envs, event.EnvironmentName, event.AccessToken); err != nil {
		return utils.Error500(utils.ResponseInput{
			Message: fmt.Sprintf("Failed to save user Environment in Identity: %v", err),
		}), err
	}

	return utils.SuccessResponse(utils.ResponseInput{
		Message: "Environment saved successfully",
	}), nil
}

func GetDBEnvironments(table *dynamo.Table, PK string) ([]UserAccountItem, error) {
	queryAction := dynamo.NewQuery[UserAccountItem](PK, "", "")
	return dynamo.Query(table, queryAction)
}

func UpdateDynamoTable(event RegisterAccountEvent, table *dynamo.Table, PK string) error {
	SK := fmt.Sprintf("ws-%s", event.EnvironmentName)
	utils.Pr(SK)
	putEnvAction := dynamo.NewPutItem(PK, SK, event.AccoutData)
	return dynamo.PutItem(table, putEnvAction)
}

func UpdateCognitoAttribute(envs string, envName string, accessToken string) error {
	workspacesKey := "custom:workspaces"
	workspacesValue := fmt.Sprintf("%s,%s", envs, envName)
	cognitoInput := &cognitoidentityprovider.UpdateUserAttributesInput{
		AccessToken: &accessToken,
		UserAttributes: []types.AttributeType{
			{
				Name:  &workspacesKey,
				Value: &workspacesValue,
			},
		},
	}
	_, err := cognitoClient.UpdateUserAttributes(context.TODO(), cognitoInput)
	return err
}
