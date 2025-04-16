package process

import (
	data_schemas "deploy_lab/dataSchemas"
	"deploy_lab/utils"
	"fmt"
	"os"
	"time"

	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/expression"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	deployment_common "github.com/mauri-codes/aws-journey/lambdas/deployer/Common"
	"github.com/mauri-codes/go-modules/aws/dynamo"
)

const (
	APPLY_ACTION   = "APPLY"
	DESTROY_ACTION = "DESTROY"
)

func CollectInputData(client *dynamodb.Client) *data_schemas.InputData {
	ACTION := os.Getenv("ACTION")
	APP_TABLE := os.Getenv("APP_TABLE")
	USER_ID := os.Getenv("USER_ID")
	LAB_ID := os.Getenv("LAB_ID")
	RUN_ID := os.Getenv("RUN_ID")
	STAGE_ID := os.Getenv("STAGE_ID")
	LAB_PATH := os.Getenv("LAB_PATH")
	USER_STATE_BUCKET := os.Getenv("USER_STATE_BUCKET")
	USER_STATE_TABLE := os.Getenv("USER_STATE_TABLE")
	CODEBUILD_BUILD_ID := os.Getenv("CODEBUILD_BUILD_ID")
	if RUN_ID == "" {
		RUN_ID = utils.StringWithCharset(3, utils.UPPER_CASE_LETTERS) + "-" + utils.StringWithCharset(3, utils.NUMBERS)
	}
	userKey := "user_" + USER_ID
	labKey := "lab_" + LAB_ID
	stageKey := "stg_" + STAGE_ID
	runKey := "run_" + RUN_ID
	timeNow := time.Now()
	currentDate := fmt.Sprintf(
		"%d-%02d-%02d %02d:%02d",
		timeNow.Year(),
		timeNow.Month(),
		timeNow.Day(),
		timeNow.Hour(),
		timeNow.Minute(),
	)
	appTable := dynamo.NewTable(APP_TABLE, "pk", "sk", client)
	userStateTable := dynamo.NewTable(USER_STATE_TABLE, "LockID", "", client)
	deploymentPk := userKey + "#" + labKey + "#" + stageKey + "#" + "deployments"
	deploymentSk := runKey + "#" + ACTION
	accountsPk := userKey
	accountsSk := "accounts"
	UserStateHashKeyValue := USER_STATE_BUCKET + "/users_state/" + USER_ID + "/" + LAB_ID + "/" + RUN_ID + ".tfstate-md5"
	expiration := time.Now().Unix() + 10*60*60*24
	userStateStatusBuild := expression.Set(expression.Name("Expires"), expression.Value(expiration))
	userStateStatusExp, _ := expression.NewBuilder().WithUpdate(userStateStatusBuild).Build()
	// updateStatusBuild := expression.Set(expression.Name("Status"), expression.Value(data_schemas.COMPLETED))
	// updateStatusExp, _ := expression.NewBuilder().WithUpdate(updateStatusBuild).Build()
	return &data_schemas.InputData{
		Action:            ACTION,
		LabId:             LAB_ID,
		UserId:            USER_ID,
		RunId:             RUN_ID,
		StageId:           STAGE_ID,
		LabPath:           LAB_PATH,
		DeploymentSk:      deploymentSk,
		DeploymentPk:      deploymentPk,
		AppTable:          appTable,
		UserStateTable:    userStateTable,
		CurrentDate:       currentDate,
		CodebuildId:       CODEBUILD_BUILD_ID,
		GetAccountData:    dynamo.NewGetItem[*data_schemas.UserAccounts](accountsPk, accountsSk),
		GetDeploymentData: dynamo.NewGetItem[*deployment_common.DeploymentRun](deploymentPk, deploymentSk),
		UpdateUserState:   dynamo.NewUpdateItem[any](UserStateHashKeyValue, "", userStateStatusExp),
	}
}
