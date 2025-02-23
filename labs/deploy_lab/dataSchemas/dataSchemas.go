package data_schemas

import (
	deployment_common "github.com/mauri-codes/aws-journey/lambdas/deployer/Common"
	"github.com/mauri-codes/go-modules/aws/dynamo"
)

type InputData struct {
	Action            string
	LabId             string
	UserId            string
	RunId             string
	AppTable          *dynamo.Table
	UserStateTable    *dynamo.Table
	GetDeploymentData dynamo.IItemAction[*deployment_common.DeploymentRun]
	GetAccountData    dynamo.IItemAction[*UserAccounts]
	UpdateUserState   dynamo.IItemAction[any]
	CurrentDate       string
	CodebuildId       string
}
