locals {
  vpc_cidr_block = "10.16.0.0/16"
  subnet_prefix = "sn-"
  subnet_definition = {
    "${local.subnet_prefix}web-A" = {
      cidr_block = "10.16.0.0/20"
      az         = "us-east-1a"
    }
    "${local.subnet_prefix}web-B" = {
      cidr_block = "10.16.16.0/20"
      az         = "us-east-1b"
    }
    "${local.subnet_prefix}web-C" = {
      cidr_block = "10.16.32.0/20"
      az         = "us-east-1c"
    }
    "${local.subnet_prefix}app-A" = {
      cidr_block = "10.16.64.0/20"
      az         = "us-east-1a"
    }
    "${local.subnet_prefix}app-B" = {
      cidr_block = "10.16.80.0/20"
      az         = "us-east-1b"
    }
    "${local.subnet_prefix}app-C" = {
      cidr_block = "10.16.96.0/20"
      az         = "us-east-1c"
    }
    "${local.subnet_prefix}db-A" = {
      cidr_block = "10.16.128.0/20"
      az         = "us-east-1a"
    }
    "${local.subnet_prefix}db-B" = {
      cidr_block = "10.16.144.0/20"
      az         = "us-east-1b"
    }
    "${local.subnet_prefix}db-C" = {
      cidr_block = "10.16.160.0/20"
      az         = "us-east-1c"
    }
  }
}