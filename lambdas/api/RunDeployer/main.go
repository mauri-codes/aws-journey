package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/sfn"
	"github.com/google/uuid"
	t "github.com/mauri-codes/go-modules/utils"
)

var sfnClient *sfn.Client

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("Failed to load configuration, %v", err)
	}

	sfnClient = sfn.NewFromConfig(cfg)
}

func main() {
	lambda.Start(handleRequest)
}

type RunDeployerEvent struct {
	Action      string
	UserId      string
	LabId       string
	EnvName     string
	LabPath     string
	StageId     string
	RunId       string
	ExecutionId string
	Params      map[string]string
}

type RunDeployerResponse struct {
	Status      string
	RunId       string
	ExecutionId string
	Message     *string
}

func handleRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var order RunDeployerEvent
	if err := json.Unmarshal([]byte(request.Body), &order); err != nil {
		errMessage := fmt.Sprintf("Failed to unmarshal event: %v", err)
		return ErrorResponse(errMessage), err
	}

	id := uuid.New().String()
	if order.RunId == "" {
		shortId := strings.Split(id, "-")[0]
		t.Pr(id)
		order.RunId = shortId
	}
	order.ExecutionId = id
	t.Pr(id)
	t.Pr(order)

	out, err := json.Marshal(order)
	if err != nil {
		errMessage := fmt.Sprintf("Failed to marshal event: %v", err)
		return ErrorResponse(errMessage), err
	}
	stringEvent := string(out)

	stateMachineArn := os.Getenv("STEP_FUNCTIONS")
	sfnClient.StartExecution(context.TODO(), &sfn.StartExecutionInput{
		StateMachineArn: &stateMachineArn,
		Name:            &id,
		Input:           &stringEvent,
	})

	return SuccessResponse(order), nil
}

func ErrorResponse(message string) events.APIGatewayProxyResponse {
	log.Print(message)
	out, _ := json.Marshal(RunDeployerResponse{
		Message: &message,
		Status:  "ERROR",
	})
	return events.APIGatewayProxyResponse{Body: string(out), StatusCode: 500}
}

func SuccessResponse(event RunDeployerEvent) events.APIGatewayProxyResponse {
	message := event.Action + " Order Started"
	out, _ := json.Marshal(RunDeployerResponse{
		Message:     &message,
		Status:      "SUCCESS",
		RunId:       event.RunId,
		ExecutionId: event.ExecutionId,
	})
	return events.APIGatewayProxyResponse{Body: string(out), StatusCode: 200}
}
