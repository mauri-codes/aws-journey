package main

import (
	"context"
	data_schemas "deploy_lab/dataSchemas"
	aws_dynamo "deploy_lab/dynamodb"
	"deploy_lab/process"
	"log"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/expression"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

func main() {
	input := process.CollectInputData()
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("Failed to load configuration, %v", err)
	}
	dbClient := dynamodb.NewFromConfig(cfg)
	err = Deployment(dbClient, input)
	if err != nil {
		log.Fatal(err.Error())
		CreateFailedStatus(dbClient, input)
	}
}

func Deployment(dbClient *dynamodb.Client, input *data_schemas.InputData) error {
	err := aws_dynamo.PutItem(dbClient, input.PutDeployStatus)
	if err != nil {
		return err
	}
	err = process.SetAccountData(dbClient, input.AccountsQuery, input.RunId)
	if err != nil {
		return err
	}
	err = process.TerraformCommand(input.Action, input.LabId)
	if err != nil {
		return err
	}
	err = aws_dynamo.UpdateItem(dbClient, input.UpdateUserState)
	if err != nil {
		return err
	}
	return aws_dynamo.UpdateItem(dbClient, input.UpdateDeployStatus)
}

func CreateFailedStatus(client *dynamodb.Client, input *data_schemas.InputData) {
	updateStatusBuild := expression.Set(expression.Name("Status"), expression.Value(data_schemas.FAILED))
	updateStatusExp, _ := expression.NewBuilder().WithUpdate(updateStatusBuild).Build()
	input.UpdateDeployStatus.Expression = updateStatusExp
	aws_dynamo.UpdateItem(client, input.UpdateDeployStatus)
}
