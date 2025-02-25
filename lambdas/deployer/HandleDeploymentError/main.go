package main

import (
	"context"
	"encoding/json"
	data_types "handle_deployment_err/schemas"
	t "handle_deployment_err/utils"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/expression"
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
	// testLocally()
}

func testLocally() {
	res, _ := json.Marshal(
		deployment_common.CodebuildResults{
			DeployData: deployment_common.DeployData{
				Action: "APPLY",
				UserId: "test1",
				LabId:  "S3Website",
				RunId:  "XLC-123",
			},
			BuildId: "11223345",
		},
	)
	handleRequest(context.TODO(), res)
}

func handleRequest(ctx context.Context, event json.RawMessage) error {
	t.Pr(event)
	var step data_types.ProcessError
	if err := json.Unmarshal(event, &step); err != nil {
		log.Printf("Failed to unmarshal Step event: %v", err)
		return err
	}

	var deployerEvent *deployment_common.CodebuildResults
	if step.Step == data_types.START_DEPLOYMENT_STEP {
		if err := json.Unmarshal(event, &deployerEvent); err != nil {
			log.Printf("Failed to unmarshal deployer event: %v", err)
			return err
		}
	} else {
		var deployerEventOriginal deployment_common.CodebuildResultsOriginal
		if err := json.Unmarshal(event, &deployerEventOriginal); err != nil {
			log.Printf("Failed to unmarshal event: %v", err)
			return err
		}
		deployerEvent = deployment_common.GetCodebuildResults(deployerEventOriginal)
	}
	appTable := os.Getenv("APP_TABLE")

	t.Pr(appTable)
	t.Pr(deployerEvent)
	updateStatus := expression.Set(
		expression.Name("Status"),
		expression.Value(deployment_common.FAILED),
	)
	updateStatus.Set(
		expression.Name("BuildId"),
		expression.Value(deployerEvent.BuildId),
	)
	updateStatus.Set(
		expression.Name("Step"),
		expression.Value(step.Step),
	)

	if step.Step == data_types.DEPLOY_STEP {
		updateStatus.Set(
			expression.Name("ErrorPhases"),
			expression.Value(deployerEvent.ErrorPhases),
		)
	}

	updateStatusExp, err := expression.NewBuilder().WithUpdate(updateStatus).Build()
	if err != nil {
		t.Pr(updateStatus)
		return err
	}

	pk := deployment_common.GetAppTableHashKey(deployerEvent.UserId, deployerEvent.LabId)
	sk := deployment_common.GetAppTableSortKey(deployerEvent.RunId, deployerEvent.Action)

	table := dynamo.NewTable(appTable, "pk", "sk", dbClient)
	action := dynamo.NewUpdateItem[deployment_common.DeploymentRun](pk, sk, updateStatusExp)

	err = dynamo.UpdateItem(table, action)

	if err != nil {
		log.Fatalf("Failed Create Deployment item, %v", err)
	}

	return nil
}
