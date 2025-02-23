package main

import (
	"context"
	data_schemas "deploy_lab/dataSchemas"
	"deploy_lab/process"
	"log"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/mauri-codes/go-modules/aws/dynamo"
)

func main() {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("Failed to load configuration, %v", err)
	}
	dbClient := dynamodb.NewFromConfig(cfg)
	input := process.CollectInputData(dbClient)
	err = Deployment(input)
	if err != nil {
		log.Fatal(err.Error())
	}
}

func Deployment(input *data_schemas.InputData) error {
	err := process.SetAccountData(input)
	if err != nil {
		return err
	}
	err = process.TerraformCommand(input.Action, input.LabId)
	if err != nil {
		return err
	}
	err = dynamo.UpdateItem(input.UserStateTable, input.UpdateUserState)
	if err != nil {
		return err
	}
	return nil
}

// func CreateFailedStatus(client *dynamodb.Client, input *data_schemas.InputData, err error) {
// 	updateStatusBuild := expression.Set(expression.Name("Status"), expression.Value(data_schemas.FAILED))
// 	updateStatusBuild.Add(expression.Name("ErrorMessage"), expression.Value(err.Error()))
// 	updateStatusExp, _ := expression.NewBuilder().WithUpdate(updateStatusBuild).Build()
// 	input.UpdateDeployStatus.Expression = updateStatusExp
// 	aws_dynamo.UpdateItem(client, input.UpdateDeployStatus)
// }
