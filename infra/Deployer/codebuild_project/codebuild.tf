resource "aws_codebuild_project" "project" {
  name          = var.codebuild_project_name
  description   = "Deploys labs to external accounts"
  build_timeout = var.build_timeout
  service_role  = var.codebuild_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.codebuild_image
    type                        = "ARM_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"

    environment_variable {
      name  = "ACTION"
      value = ""
    }
    environment_variable {
      name  = "LAB_ID"
      value = ""
    }
    environment_variable {
      name  = "ENV_NAME"
      value = ""
    }
    environment_variable {
      name  = "LAB_PATH"
      value = ""
    }
    environment_variable {
      name  = "USER_ID"
      value = ""
    }
    environment_variable {
      name  = "RUN_ID"
      value = ""
    }
    environment_variable {
      name  = "STAGE_ID"
      value = ""
    }
    environment_variable {
      name  = "USER_STATE_BUCKET"
      value = var.state_bucket
    }
    environment_variable {
      name  = "USER_STATE_TABLE"
      value = var.user_state_table
    }
    environment_variable {
      name  = "APP_TABLE"
      value = var.app_table
    }
  }

  source {
    type      = "NO_SOURCE"
    buildspec = file("${path.module}/buildspec.yaml")
  }
}
