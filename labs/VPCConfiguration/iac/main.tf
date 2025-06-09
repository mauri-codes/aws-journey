module "vpc" {
  source                = "./modules/vpc"
  VpcName               = var.VpcName
  InternetGatewayName   = var.InternetGatewayName
  PrivateRouteTableName = var.PrivateRouteTableName
  PublicRouteTableName  = var.PublicRouteTableName
  vpc_cidr_block        = local.vpc_cidr_block
  subnet_definition     = local.subnet_definition
  subnet_prefix         = local.subnet_prefix
  suffix                = var.suffix
  providers = {
    aws = aws.account1_A
  }
}
