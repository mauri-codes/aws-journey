resource "aws_sfn_state_machine" "deployer" {
  name     = var.state_machine_name
  role_arn = module.state_machine_role.role_arn
  definition = templatefile("${path.module}/statemachine.asl.json", {
    StartDeploymentFunctionArn = var.start_deployment_lambda_arn
    DeployCodebuildProjectArn  = var.codebuild_project_arn
    CloseDeploymentFunctionArn = var.close_deployment_lambda_arn
    ErrorHandlerArn            = var.error_handler_lambda_arn
    }
  )
}
