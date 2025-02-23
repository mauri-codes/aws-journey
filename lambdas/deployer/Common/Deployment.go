package deployment_common

type DeploymentRun struct {
	DeployerEvent
	PK     string `dynamodbav:"pk"`
	SK     string `dynamodbav:"sk"`
	Status string
}

type DeployerEvent struct {
	Action string
	UserId string
	LabId  string
	RunId  string
	Params map[string]string
}

type Output struct {
	Action string
	UserId string
	LabId  string
	RunId  string
}

func NewOutput(event *DeployerEvent) *Output {
	return &Output{
		Action: event.Action,
		UserId: event.UserId,
		LabId:  event.LabId,
		RunId:  event.RunId,
	}
}

func NewDeploymentRun(deploymentEvent DeployerEvent, pk string, sk string) *DeploymentRun {
	return &DeploymentRun{
		DeployerEvent: deploymentEvent,
		PK:            pk,
		SK:            sk,
		Status:        RUNNING,
	}
}

const (
	RUNNING = "RUNNING"
	FAILED  = "FAILED"
	SUCCESS = "SUCCESS"
)
