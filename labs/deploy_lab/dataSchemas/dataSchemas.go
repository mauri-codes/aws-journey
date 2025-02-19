package data_schemas

import table_key "deploy_lab/dynamodb/TableKey"

type InputData struct {
	Action             string
	LabId              string
	UserId             string
	RunId              string
	AccountsQuery      *table_key.TableData[any]
	PutDeployStatus    *table_key.TableData[DeployStatus]
	UpdateUserState    *table_key.TableData[any]
	UpdateDeployStatus *table_key.TableData[DeployStatus]
	CurrentDate        string
	CodebuildId        string
}
