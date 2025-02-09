package data_schemas

const (
	RUNNING   = "RUNNING"
	COMPLETED = "COMPLETED"
	FAILED    = "FAILED"
)

type DeployStatus struct {
	PK     string `dynamodbav:"pk"`
	SK     string `dynamodbav:"sk"`
	Status string
	Date   string
}
