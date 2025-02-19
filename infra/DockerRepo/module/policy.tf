data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "pull" {
  statement {
    sid    = "AllowCodebuildPull"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:role/${var.codebuild_role_name}"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      # "ecr:PutImage",
      # "ecr:InitiateLayerUpload",
      # "ecr:UploadLayerPart",
      # "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      # "ecr:DeleteRepository",
      # "ecr:BatchDeleteImage",
      # "ecr:SetRepositoryPolicy",
      # "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.deployer.name
  policy     = data.aws_iam_policy_document.pull.json
}