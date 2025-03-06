package process

import (
	data_schemas "deploy_lab/dataSchemas"
	custom_error "deploy_lab/errors"
	error_codes "deploy_lab/errors/errorCodes"
	"deploy_lab/utils"
	"os"

	deployment_common "github.com/mauri-codes/aws-journey/lambdas/deployer/Common"
	"github.com/mauri-codes/go-modules/aws/dynamo"
)

func SetAccountData(input *data_schemas.InputData) custom_error.ICustomError {
	var err error
	var userAccounts *data_schemas.UserAccounts
	var deploymentData *deployment_common.DeploymentRun
	userAccounts, err = dynamo.GetItem(
		input.AppTable,
		input.GetAccountData,
	)
	if err != nil {
		return custom_error.NewCustomError(error_codes.GET_ACCOUNT_DATA_FAILED, err.Error())
	}
	deploymentData, err = dynamo.GetItem(
		input.AppTable,
		input.GetDeploymentData,
	)
	if err != nil {
		return custom_error.NewCustomError(error_codes.GET_DEPLOYMENT_DATA_FAILED, err.Error())
	}
	if userAccounts.Account_B == "" {
		userAccounts.Account_B = userAccounts.Account_A
	}
	err = os.Setenv("ACCOUNT_A_ROLE", userAccounts.Account_A)
	if err != nil {
		return custom_error.NewCustomError(error_codes.GET_ENV_VARIABLE_FAILED, "ACCOUNT_A_ROLE: "+err.Error())
	}
	err = os.Setenv("ACCOUNT_B_ROLE", userAccounts.Account_B)
	if err != nil {
		return custom_error.NewCustomError(error_codes.GET_ENV_VARIABLE_FAILED, "ACCOUNT_B_ROLE: "+err.Error())
	}
	err = os.Setenv("REGION_A", userAccounts.Region_A)
	if err != nil {
		return custom_error.NewCustomError(error_codes.GET_ENV_VARIABLE_FAILED, "REGION_A: "+err.Error())
	}
	err = os.Setenv("REGION_B", userAccounts.Region_B)
	if err != nil {
		return custom_error.NewCustomError(error_codes.GET_ENV_VARIABLE_FAILED, "REGION_B: "+err.Error())
	}
	err = os.Setenv("RUN_ID", input.RunId)
	if err != nil {
		return custom_error.NewCustomError(error_codes.GET_ENV_VARIABLE_FAILED, "RUN_ID: "+err.Error())
	}
	utils.Pr("Params")
	utils.Pr(deploymentData.Params)
	for key, val := range deploymentData.Params {
		err = os.Setenv(key, val)
		if err != nil {
			return custom_error.NewCustomError(error_codes.SET_ENV_VARIABLE_FAILED, key+": "+err.Error())
		}
	}
	return nil
}
