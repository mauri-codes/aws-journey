package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"sync"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/expression"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/mauri-codes/go-modules/aws/dynamo"
	"github.com/mauri-codes/go-modules/utils"
)

var dbClient *dynamodb.Client
var appTable string

func init() {
	appTable = os.Getenv("APP_TABLE")
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("Failed to load aws configuration, %v", err)
	}

	dbClient = dynamodb.NewFromConfig(cfg)
}

type SQSPayload struct {
	Favorite string
}

type Favorite struct {
	PK    string `dynamodbav:"pk"`
	SK    string `dynamodbav:"sk"`
	Count int
}

func main() {
	lambda.Start(handleRequest)
}

func handleRequest(ctx context.Context, event events.SQSEvent) error {
	summary := make(map[string]int)
	for _, message := range event.Records {
		payload := SQSPayload{}
		json.Unmarshal([]byte(message.Body), &payload)
		summary[payload.Favorite] += 1
	}
	var wg sync.WaitGroup
	utils.Pr(summary)
	for key, count := range summary {
		wg.Add(1)
		go UpdateDynamoRecord(key, count, &wg)
	}
	wg.Wait()
	utils.Pr("FINISHED")
	return nil
}

func UpdateDynamoRecord(name string, count int, wg *sync.WaitGroup) error {
	defer wg.Done()
	pk := "Favorite"
	sk := name
	updateStatus := expression.Add(
		expression.Name("Status"),
		expression.Value(count),
	)
	updateStatusExp, _ := expression.NewBuilder().WithUpdate(updateStatus).Build()
	table := dynamo.NewTable(appTable, "pk", "sk", dbClient)
	action := dynamo.NewUpdateItem[Favorite](pk, sk, updateStatusExp)
	err := dynamo.UpdateItem(table, action)
	if err != nil {
		fmt.Printf("Failed to update deployment item, %v", err)
	}
	return nil
}
