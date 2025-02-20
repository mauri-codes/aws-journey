package deployment_common

type DeploymentRun struct {
	DeployerEvent
	Status string
	Error  string
}

type DeployerEvent struct {
	Action string
	UserId string
	LabId  string
	RunId  string
}

func NewDeploymentRun(deploymentEvent DeployerEvent) *DeploymentRun {
	return &DeploymentRun{
		DeployerEvent: deploymentEvent,
	}
}

const (
	RUNNING = "RUNNING"
	FAILED  = "FAILED"
	SUCCESS = "SUCCESS"
)
