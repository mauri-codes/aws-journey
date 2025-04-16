package main

import (
	t "close_deployment/utils"
	"context"
	"encoding/json"
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
				RunId:  "",
			},
			BuildId:     "47d5edee-37ff-42e1-8154-8eaf56a283f2",
			ProjectName: "LabDeployer",
		},
	)
	s := handleRequest(context.TODO(), res)
	t.Pr(s)
}

func handleRequest(ctx context.Context, event json.RawMessage) error {
	t.Pr(event)
	var deployerEventOriginal deployment_common.CodebuildResultsOriginal
	var deployerEvent *deployment_common.CodebuildResults
	if err := json.Unmarshal(event, &deployerEventOriginal); err != nil {
		log.Printf("Failed to unmarshal event: %v", err)
		return err
	}
	deployerEvent = deployment_common.GetCodebuildResults(deployerEventOriginal)

	appTable := os.Getenv("APP_TABLE")
	t.Pr(appTable)
	t.Pr(deployerEvent)
	updateStatus := expression.Set(
		expression.Name("Status"),
		expression.Value(deployment_common.SUCCESS),
	).Set(
		expression.Name("BuildId"),
		expression.Value(deployerEvent.BuildId),
	)
	updateStatusExp, _ := expression.NewBuilder().WithUpdate(updateStatus).Build()

	pk := deployment_common.GetAppTableHashKey(deployerEvent.UserId, deployerEvent.LabId, deployerEvent.StageId)
	sk := deployment_common.GetAppTableSortKey(deployerEvent.RunId, deployerEvent.Action)

	table := dynamo.NewTable(appTable, "pk", "sk", dbClient)
	action := dynamo.NewUpdateItem[deployment_common.DeploymentRun](pk, sk, updateStatusExp)

	err := dynamo.UpdateItem(table, action)
	if err != nil {
		log.Fatalf("Failed to update deployment item, %v", err)
	}

	return nil
}
