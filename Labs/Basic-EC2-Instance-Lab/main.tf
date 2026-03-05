terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.34.0"
    }
  }
  backend "s3" {
    bucket = "cloud-pathway-terraformstate-webbase"
    key = "dev.tfstate"
    region = "us-east-1"
    encrypt = true

  }
}




########Instance#########


#Create a VPC
resource "aws_vpc" "MYVPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Devops-Detroit-VPC"
  }
}


#Create Public Subnet
resource "aws_subnet" "Public_Subnet" {
  vpc_id = aws_vpc.MYVPC.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet"
  }
}




#Create Internet Gateway
resource "aws_internet_gateway" "MyInternetGateway" {
    vpc_id = aws_vpc.MYVPC.id
    tags = {
      Name = "MyInternetGateway"
    }
}


#Create Routing Table
resource "aws_route_table" "Public_Routing_Table" {
    vpc_id = aws_vpc.MYVPC.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.MyInternetGateway.id

        
    }
    tags = {
      Name = "Public Routing TB"
    }
  
}


resource "aws_security_group" "Public_security_Group" {
    name = "Public Security Group"
    description = "Rules for the public EC2 instances"
    vpc_id = aws_vpc.MYVPC.id
  
}

resource "aws_security_group_rule" "Allow_ssh" {
    type = "ingress"
    to_port = 22
    security_group_id = aws_security_group.Public_security_Group.id
    protocol = "tcp"
    from_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  
}

resource "aws_security_group_rule" "outbound" {
    type = "egress"
    to_port = 0 #ALL ports
    from_port = 0 #ALl Ports
    security_group_id = aws_security_group.Public_security_Group.id
    protocol = "-1" #All protocols 
    cidr_blocks = ["0.0.0.0/0"]
  
}

#Subnet Association to Routing table
resource "aws_route_table_association" "Public_Subnet_to_Public_RT" {
  subnet_id = aws_subnet.Public_Subnet.id
  route_table_id = aws_route_table.Public_Routing_Table.id
  
}



resource "aws_instance" "Public_Ec2_instance_1" {
  ami                     = "ami-07761f3ae34c4478d"
  instance_type           = "t2.micro"
  
  subnet_id = aws_subnet.Public_Subnet.id
  vpc_security_group_ids = [aws_security_group.Public_security_Group.id]
 
  tags = {
    Name = "Publc_EC2_instance_1"
  }
  
}
