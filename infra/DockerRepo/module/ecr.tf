resource "aws_ecr_repository" "deployer" {
  name                 = var.deployer_name
  image_tag_mutability = "MUTABLE"
}
