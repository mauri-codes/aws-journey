data "aws_region" "current" {}
module "bucket" {
  source  = "./modules/Bucket"
  bucket_name = var.bucket_name
}

module "cloudfront_distribution" {
  source  = "./modules/Distribution"
  bucket_name = var.bucket_name
  region = data.aws_region.current.name
  # count = var.base_infrastructure ? 0 : 1
}
