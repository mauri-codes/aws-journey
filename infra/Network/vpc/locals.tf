locals {
    vpc_cidr = "${var.ip_range_prefix}.0.0/16"
    subnets = {
        # AZ-A subnets
        "sn-web-A" = {
            cidr_block_suffix = "0.0/20"
            az = "us-east-1a"
        }
        "sn-app-A" = {
            cidr_block_suffix = "16.0/20"
            az = "us-east-1a"
        }
        # "sn-db-A" = {
        #     cidr_block_suffix = "32.0/20"
        #     az = "us-east-1a"
        # }
        # "sn-reserved-A" = {
        #     cidr_block_suffix = "48.0/20"
        #     az = "us-east-1a"
        # }
        # AZ-B subnets
        "sn-web-B" = {
            cidr_block_suffix = "64.0/20"
            az = "us-east-1b"
        }
        "sn-app-B" = {
            cidr_block_suffix = "80.0/20"
            az = "us-east-1b"
        }
        # "sn-db-B" = {
        #     cidr_block_suffix = "96.0/20"
        #     az = "us-east-1b"
        # }
        # "sn-reserved-B" = {
        #     cidr_block_suffix = "112.0/20"
        #     az = "us-east-1b"
        # }
        # AZ-C subnets
        "sn-web-C" = {
            cidr_block_suffix = "128.0/20"
            az = "us-east-1c"
        }
        "sn-app-C" = {
            cidr_block_suffix = "144.0/20"
            az = "us-east-1c"
        }
        # "sn-db-C" = {
        #     cidr_block_suffix = "160.0/20"
        #     az = "us-east-1c"
        # }
        # "sn-reserved-C" = {
        #     cidr_block_suffix = "176.0/20"
        #     az = "us-east-1c"
        # }
    }
}