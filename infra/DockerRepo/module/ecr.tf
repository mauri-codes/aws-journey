resource "aws_ecr_repository" "deployer" {
  name                 = local.repo_name
  image_tag_mutability = "MUTABLE"
}
