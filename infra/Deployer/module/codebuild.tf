resource "aws_codebuild_project" "example" {
  name          = "LabDeployer"
  description   = "Deploys labs to external accounts"
  build_timeout = var.build_timeout
  service_role  = module.codebuild_role.role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = local.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "ACTION"
      value = "Deploy"
    }
    environment_variable {
      name  = "REPO"
      value = var.repo
    }
    environment_variable {
      name  = "LAB_ID"
      value = ""
    }
    environment_variable {
      name  = "USER_ID"
      value = ""
    }
    environment_variable {
      name  = "USER_STATE_BUCKET"
      value = var.state_bucket
    }
    environment_variable {
      name  = "USER_STATE_TABLE"
      value = var.state_table
    }
  }

  source {
    type      = "NO_SOURCE"
    buildspec = file("${path.module}/buildspec.yaml")
  }
}
