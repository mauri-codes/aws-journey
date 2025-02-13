data "aws_region" "current" {}
module "bucket" {
  providers = {
    aws = aws.account1_A
  }
  source  = "./modules/Bucket"
  bucket_name = var.bucket_name
}

# module "cloudfront_distribution" {
#   providers = {
#     aws = aws.account1_A
#   }
#   source  = "./modules/Distribution"
#   bucket_name = var.bucket_name
#   region = data.aws_region.current.name
#   # count = var.base_infrastructure ? 0 : 1
# }
