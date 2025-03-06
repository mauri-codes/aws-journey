package main

import (
	"context"
	data_schemas "deploy_lab/dataSchemas"
	custom_error "deploy_lab/errors"
	error_codes "deploy_lab/errors/errorCodes"
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
	depErr := Deployment(input)
	if depErr != nil {
		// UpdateDeploymentStatus(depErr, input)
		log.Fatal(err.Error())
	}
}

func Deployment(input *data_schemas.InputData) custom_error.ICustomError {
	err := process.SetAccountData(input)
	if err != nil {
		return err
	}
	err = process.TerraformCommand(input.Action, input.LabId)
	if err != nil {
		return err
	}
	updateError := dynamo.UpdateItem(input.UserStateTable, input.UpdateUserState)
	if updateError != nil {
		return custom_error.NewCustomError(error_codes.UPDATE_DEPLOYMENT_DATA_FAILED, updateError.Error())
	}
	return nil
}
