package deployment_common

func GetAppTableHashKey(userId string, labId string, stageId string) string {
	return "user_" + userId + "#lab_" + labId + "#stg_" + stageId + "#" + "deployments"
}

func GetAppTableSortKey(runId string, action string) string {
	return "run_" + runId + "#" + action
}
