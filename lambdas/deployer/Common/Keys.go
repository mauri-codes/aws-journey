package deployment_common

func GetAppTableHashKey(userId string, labId string) string {
	return "user_" + userId + "#lab_" + labId
}

func GetAppTableSortKey(runId string, action string) string {
	return "run_" + runId + "#" + action
}
