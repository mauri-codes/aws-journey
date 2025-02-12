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
      name  = "Action"
      value = "Deploy"
    }
    environment_variable {
      name  = "Repo"
      value = var.repo
    }
    environment_variable {
      name  = "Lab"
      value = ""
    }
    environment_variable {
      name  = "StateBucket"
      value = ""
    }
    environment_variable {
      name  = "StateTable"
      value = ""
    }
  }

  source {
    type            = "NO_SOURCE"
    buildspec = file("${path.module}/buildspec.yaml")
  }
}
