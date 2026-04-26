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
    source = "../../my_modules/VPC"
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

module "EC2" {
  for_each         = { for vpc in local.vpc_config_set : vpc.vpc_name => vpc }
  source           = "../../my_modules/EC2"
  instance_name    = "Instance-${each.key}"
  vpc_id           = module.VPC[each.key].vpc_id
  public_subnet_id = module.VPC[each.key].public_subnet_id
  sg_ports         = ["22", "443"]
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  for_each          = { for vpc in local.vpc_config_set : vpc.vpc_name => vpc }
  name              = "/aws/vpc/flow-logs/${each.key}"
  retention_in_days = 7
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "vpc-flow-logs-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "vpc-flow-logs-policy"
  role = aws_iam_role.vpc_flow_logs_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_flow_log" "vpc_flow_logs" {
  for_each        = { for vpc in local.vpc_config_set : vpc.vpc_name => vpc }
  vpc_id          = module.VPC[each.key].vpc_id
  traffic_type    = "ALL"
  iam_role_arn    = aws_iam_role.vpc_flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs[each.key].arn
}
