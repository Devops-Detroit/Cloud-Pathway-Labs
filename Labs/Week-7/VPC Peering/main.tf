terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.35.1"
    }
  }
   backend "s3" {
    bucket = "cloud-pathway-terraformstate-webbase"
    key = "dev.tfstate"
    region = "us-east-1"
    encrypt = true

  }
}

locals {
  vpc_config_set = [{
    vpc_name = "Devops-Detroit-VPC-A"
    vpc_cidr = "10.0.0.0/16"
    availability_zone_1 = "us-east-1a"
},
{
    vpc_name = "Devops-Detroit-VPC-B"
    vpc_cidr = "10.1.0.0/16"
    availability_zone_1 = "us-east-1b"
}
]
}

module "VPC" {
    for_each = { for vpc in local.vpc_config_set : vpc.vpc_name => vpc }
    vpc_name = each.value.vpc_name
    source = "../my_modules/VPC"
    vpc_cidr = each.value.vpc_cidr
    availability_zone_1 = each.value.availability_zone_1
}

resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = module.VPC["Devops-Detroit-VPC-A"].vpc_id
  peer_vpc_id = module.VPC["Devops-Detroit-VPC-B"].vpc_id
  auto_accept = true
}

resource "aws_route" "a_to_b" {
  route_table_id            = module.VPC["Devops-Detroit-VPC-A"].public_route_table_id
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "b_to_a" {
  route_table_id            = module.VPC["Devops-Detroit-VPC-B"].public_route_table_id
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
