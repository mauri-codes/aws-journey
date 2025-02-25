package data_types

const (
	START_DEPLOYMENT_STEP = "StartDeployment"
	DEPLOY_STEP           = "Deploy"
	CLOSE_DEPLOYMENT_STEP = "CloseDeployment"
)

type ProcessError struct {
	Step string
}
