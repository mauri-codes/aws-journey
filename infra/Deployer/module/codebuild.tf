resource "aws_codebuild_project" "example" {
  name          = "LabDeployer"
  description   = "Deploys labs to external accounts"
  build_timeout = 5
  service_role  = module.codebuild_role.role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    # environment_variable {
    #   name  = "SOME_KEY2"
    #   value = "SOME_VALUE2"
    #   type  = "PARAMETER_STORE"
    # }
  }

  # logs_config {
  #   cloudwatch_logs {
  #     group_name  = "log-group"
  #     stream_name = "log-stream"
  #   }

  #   s3_logs {
  #     status   = "ENABLED"
  #     location = "${aws_s3_bucket.example.id}/build-log"
  #   }
  # }

  source {
    type            = "NO_SOURCE"
    buildspec = "version: 0.2\n\nphases:\n  build:\n    commands:\n      - command"
  }

  # vpc_config {
  #   vpc_id = aws_vpc.example.id

  #   subnets = [
  #     aws_subnet.example1.id,
  #     aws_subnet.example2.id,
  #   ]

  #   security_group_ids = [
  #     aws_security_group.example1.id,
  #     aws_security_group.example2.id,
  #   ]
  # }

  # tags = {
  #   Environment = "Test"
  # }
}
