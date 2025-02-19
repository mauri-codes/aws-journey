package process

import (
	data_schemas "deploy_lab/dataSchemas"
	table_key "deploy_lab/dynamodb/TableKey"
	"deploy_lab/utils"
	"fmt"
	"os"
	"time"

	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/expression"
)

const (
	APPLY_ACTION   = "APPLY"
	DESTROY_ACTION = "DESTROY"
)

func CollectInputData() *data_schemas.InputData {
	ACTION := os.Getenv("ACTION")
	APP_TABLE := os.Getenv("APP_TABLE")
	USER_ID := os.Getenv("USER_ID")
	LAB_ID := os.Getenv("LAB_ID")
	RUN_ID := os.Getenv("RUN_ID")
	USER_STATE_BUCKET := os.Getenv("USER_STATE_BUCKET")
	USER_STATE_TABLE := os.Getenv("USER_STATE_TABLE")
	CODEBUILD_BUILD_ID := os.Getenv("CODEBUILD_BUILD_ID")
	if RUN_ID == "" {
		RUN_ID = utils.StringWithCharset(3, utils.UPPER_CASE_LETTERS) + "-" + utils.StringWithCharset(3, utils.NUMBERS)
	}
	userKey := "user_" + USER_ID
	labKey := "lab_" + LAB_ID
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
	expiration := time.Now().Unix() + 10*60*60*24
	userStateStatusBuild := expression.Set(expression.Name("Expires"), expression.Value(expiration))
	userStateStatusExp, _ := expression.NewBuilder().WithUpdate(userStateStatusBuild).Build()
	updateStatusBuild := expression.Set(expression.Name("Status"), expression.Value(data_schemas.COMPLETED))
	updateStatusExp, _ := expression.NewBuilder().WithUpdate(updateStatusBuild).Build()
	return &data_schemas.InputData{
		Action:      ACTION,
		LabId:       LAB_ID,
		UserId:      USER_ID,
		RunId:       RUN_ID,
		CurrentDate: currentDate,
		CodebuildId: CODEBUILD_BUILD_ID,
		AccountsQuery: &table_key.TableData[any]{
			TableName: APP_TABLE,
			HashKey: table_key.TableKey{
				Key:   "pk",
				Value: userKey,
			},
			SortKey: table_key.TableKey{
				Key:   "sk",
				Value: "accounts",
			},
		},
		PutDeployStatus: &table_key.TableData[data_schemas.DeployStatus]{
			TableName: APP_TABLE,
			Data: data_schemas.DeployStatus{
				PK:          userKey + "#" + labKey,
				SK:          runKey + "#" + ACTION,
				Status:      data_schemas.RUNNING,
				Date:        currentDate,
				CodebuildId: CODEBUILD_BUILD_ID,
				LabId:       LAB_ID,
				UserId:      USER_ID,
				RunId:       RUN_ID,
				Action:      ACTION,
			},
		},
		UpdateDeployStatus: &table_key.TableData[data_schemas.DeployStatus]{
			TableName: APP_TABLE,
			HashKey: table_key.TableKey{
				Key:   "pk",
				Value: userKey + "#" + labKey,
			},
			SortKey: table_key.TableKey{
				Key:   "sk",
				Value: runKey + "#" + ACTION,
			},
			Expression: updateStatusExp,
		},
		UpdateUserState: &table_key.TableData[any]{
			TableName: USER_STATE_TABLE,
			HashKey: table_key.TableKey{
				Key:   "LockID",
				Value: USER_STATE_BUCKET + "/users_state/" + USER_ID + "/" + LAB_ID + "/" + RUN_ID + ".tfstate-md5",
			},
			Expression: userStateStatusExp,
		},
	}
}
