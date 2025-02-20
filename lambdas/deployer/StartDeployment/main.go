package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"
	t "start_deployment/utils"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	deployment_common "github.com/mauri-codes/aws-journey/lambdas/deployer/Common"
	"github.com/mauri-codes/go-modules/aws/dynamo"
)

var dbClient *dynamodb.Client

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("Failed to load configuration, %v", err)
	}

	dbClient = dynamodb.NewFromConfig(cfg)
}

func main() {
	lambda.Start(handleRequest)
}

func handleRequest(ctx context.Context, event json.RawMessage) error {
	var deployerEvent deployment_common.DeployerEvent
	if err := json.Unmarshal(event, &deployerEvent); err != nil {
		log.Printf("Failed to unmarshal event: %v", err)
		return err
	}

	appTable := os.Getenv("APP_TABLE")
	fmt.Println(appTable)
	t.Pr(deployerEvent)

	deploymentRun := deployment_common.NewDeploymentRun(deployerEvent)
	table := dynamo.NewTable(appTable, "pk", "sk", dbClient)
	action := dynamo.NewPutItem("user_"+deployerEvent.UserId+"#lab_"+deployerEvent.LabId, "run_"+deployerEvent.RunId, deploymentRun)

	err := dynamo.PutItem(table, action)
	if err != nil {
		log.Fatalf("Failed Create Deployment item, %v", err)
	}

	return nil
}
