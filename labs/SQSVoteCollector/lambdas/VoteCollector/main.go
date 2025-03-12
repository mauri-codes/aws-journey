package main

import (
	"context"
	"fmt"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

var dbClient *dynamodb.Client

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("Failed to load aws configuration, %v", err)
	}

	dbClient = dynamodb.NewFromConfig(cfg)
}

func main() {
	lambda.Start(handleRequest)
}

func handleRequest(ctx context.Context, event events.SQSEvent) error {
	for _, message := range event.Records {
		fmt.Printf("The message %s for event source %s = %s \n", message.MessageId, message.EventSource, message.Body)
	}

	return nil
}
