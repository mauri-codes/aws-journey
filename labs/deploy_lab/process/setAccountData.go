package process

import (
	data_schemas "deploy_lab/dataSchemas"
	"os"

	deployment_common "github.com/mauri-codes/aws-journey/lambdas/deployer/Common"
	"github.com/mauri-codes/go-modules/aws/dynamo"
)

func SetAccountData(input *data_schemas.InputData) error {
	var err error
	var userAccounts *data_schemas.UserAccounts
	var deploymentData *deployment_common.DeploymentRun
	userAccounts, err = dynamo.GetItem(
		input.AppTable,
		input.GetAccountData,
	)
	if err != nil {
		return err
	}
	deploymentData, err = dynamo.GetItem(
		input.AppTable,
		input.GetDeploymentData,
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
	err = os.Setenv("RUN_ID", input.RunId)
	if err != nil {
		return err
	}
	for key, val := range deploymentData.Params {
		err = os.Setenv(key, val)
		if err != nil {
			return err
		}
	}
	return nil
}
