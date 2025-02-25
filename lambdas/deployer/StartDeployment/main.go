package main

import (
	"context"
	"encoding/json"
	"log"
	"os"
	t "start_deployment/utils"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	deployment_common "github.com/mauri-codes/aws-journey/lambdas/deployer/Common"
	"github.com/mauri-codes/go-modules/aws/dynamo"
	"github.com/mauri-codes/go-modules/utils"
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
		deployment_common.DeployerEvent{
			DeployData: deployment_common.DeployData{
				Action: "APPLY",
				UserId: "test1",
				LabId:  "S3Website",
				RunId:  "",
			},
			Params: map[string]string{
				"hello": "",
			},
		},
	)
	s, _ := handleRequest(context.TODO(), res)
	t.Pr(s)
}

func handleRequest(ctx context.Context, event json.RawMessage) (*deployment_common.DeployData, error) {
	t.Pr(event)
	deployerEvent, err := ProcessEvent(event)
	if err != nil {
		log.Fatalf("Event Error %v", err)
	}
	t.Pr(deployerEvent)

	table, action := GetDynamoRequestData(deployerEvent)
	err = dynamo.PutItem(table, action)
	if err != nil {
		log.Fatalf("Failed Create Deployment item, %v", err)
	}

	return deployment_common.NewOutput(deployerEvent), nil
}

func ProcessEvent(event json.RawMessage) (*deployment_common.DeployerEvent, error) {
	var deployerEvent deployment_common.DeployerEvent
	terraformParams := map[string]string{}
	if err := json.Unmarshal(event, &deployerEvent); err != nil {
		log.Printf("Failed to unmarshal event: %v", err)
		return nil, err
	}
	for key, value := range deployerEvent.Params {
		terraformParams["TF_VAR_"+key] = value
	}
	deployerEvent.Params = terraformParams
	return &deployerEvent, nil
}

func GetDynamoRequestData(deployerEvent *deployment_common.DeployerEvent) (*dynamo.Table, dynamo.IItemAction[*deployment_common.DeploymentRun]) {
	appTable := os.Getenv("APP_TABLE")
	if deployerEvent.RunId == "" {
		deployerEvent.RunId = utils.RandomUpperCaseString(3) + "-" + utils.RandomNumberString(3)
	}
	pk := deployment_common.GetAppTableHashKey(deployerEvent.UserId, deployerEvent.LabId)
	sk := deployment_common.GetAppTableSortKey(deployerEvent.RunId, deployerEvent.Action)

	deploymentRun := deployment_common.NewDeploymentRun(*deployerEvent, pk, sk)
	table := dynamo.NewTable(appTable, "pk", "sk", dbClient)
	action := dynamo.NewPutItem(pk, sk, deploymentRun)
	return table, action
}
