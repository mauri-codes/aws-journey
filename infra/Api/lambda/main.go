package main

//GOARCH=amd64 GOOS=linux go build -o bootstrap main.go
import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/lambdacontext"
)

func main() {
	lambda.Start(handleRequest)
}

type RunDeployerEvent struct {
	Action string
	UserId string
	LabId  string
	RunId  string
}

func handleRequest(ctx context.Context, event json.RawMessage) error {
	var order RunDeployerEvent
	if err := json.Unmarshal(event, &order); err != nil {
		log.Printf("Failed to unmarshal event: %v", err)
		return err
	}

	appTable := os.Getenv("DYNAMODB_TABLE")
	fmt.Println(appTable)

	fmt.Println("HELLO WORLD2")
	fmt.Println(lambdacontext.FunctionName)
	return nil
}
