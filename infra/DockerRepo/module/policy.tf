data "aws_iam_policy_document" "pull" {
  statement {
    sid    = "AllowCodebuildPull"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.ecr_assume_roles
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
