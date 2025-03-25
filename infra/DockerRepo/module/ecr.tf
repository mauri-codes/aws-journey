resource "aws_ecr_repository" "deployer" {
  name                 = lower(var.repo_name)
  image_tag_mutability = "MUTABLE"
}
