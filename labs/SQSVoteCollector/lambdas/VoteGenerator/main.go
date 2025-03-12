package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	lambda.Start(handleRequest)
}

func handleRequest(ctx context.Context, event events.SQSEvent) error {
	fmt.Println("lambda works!")
	return nil
}
