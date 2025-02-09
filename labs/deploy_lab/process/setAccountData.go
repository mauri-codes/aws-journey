package process

import (
	data_schemas "deploy_lab/dataSchemas"
	aws_dynamo "deploy_lab/dynamodb"
	table_key "deploy_lab/dynamodb/TableKey"
	"os"

	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

func SetAccountData(dbClient *dynamodb.Client, tableData *table_key.TableData[any], runId string) error {
	userAccounts, err := aws_dynamo.GetItem[data_schemas.UserAccounts](
		dbClient,
		tableData,
	)
	if err != nil {
		return err
	}
	if userAccounts.Account_B == "" {
		userAccounts.Account_B = userAccounts.Account_A
	}
	err = os.Setenv("ACCOUNT_A_ROLE", userAccounts.Account_A)
	if err != nil {
		return err
	}
	err = os.Setenv("ACCOUNT_B_ROLE", userAccounts.Account_B)
	if err != nil {
		return err
	}
	err = os.Setenv("REGION_A", userAccounts.Region_A)
	if err != nil {
		return err
	}
	err = os.Setenv("REGION_B", userAccounts.Region_B)
	if err != nil {
		return err
	}
	err = os.Setenv("RUN_ID", runId)
	if err != nil {
		return err
	}
	return nil
}
