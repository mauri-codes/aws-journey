package deployment_common

import (
	"strings"
)

type DeploymentRun struct {
	DeployerEvent
	PK     string `dynamodbav:"pk"`
	SK     string `dynamodbav:"sk"`
	Status string
}

type DeployerEvent struct {
	DeployData
	Params map[string]string
}

type CodebuildResultsOriginal struct {
	BuildId      string
	LogGroupName string
	Action       []string
	UserId       []string
	LabId        []string
	RunId        []string
	ErrorPhases  []CodebuildPhase
}

type CodebuildPhase struct {
	Contexts  []CodebuildContext
	PhaseType string
}

type CodebuildContext struct {
	Message    string
	StatusCode string
}

type CodebuildResults struct {
	BuildId      string
	ProjectName  string
	LogGroupName string
	ErrorPhases  []CodebuildPhase
	ErrorLogs    []string
	DeployData
}

func GetCodebuildResults(original CodebuildResultsOriginal) *CodebuildResults {
	projectName := strings.Split(original.BuildId, ":")[0]
	buildId := strings.Split(original.BuildId, ":")[1]
	return &CodebuildResults{
		BuildId:      buildId,
		ProjectName:  projectName,
		LogGroupName: original.LogGroupName,
		DeployData: DeployData{
			Action: original.Action[0],
			UserId: original.UserId[0],
			LabId:  original.LabId[0],
			RunId:  original.RunId[0],
		},
		ErrorPhases: original.ErrorPhases,
	}
}

type DeployData struct {
	Action string
	UserId string
	LabId  string
	RunId  string
}

func NewOutput(event *DeployerEvent) *DeployData {
	return &DeployData{
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
