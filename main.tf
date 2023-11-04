provider "aws" {
  region = var.region
}

locals {
  AccountId = data.aws_caller_identity.current.account_id
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available_zones" {}

resource "aws_vpc" "web_app" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr_block           = var.ip_addresses_for_env.web_app.vpc.values.cidr_block
  tags                 = var.ip_addresses_for_env.web_app.vpc.values.tags
}

resource "aws_vpc" "bastion" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr_block           = var.ip_addresses_for_env.bastion.vpc.values.cidr_block
  tags                 = var.ip_addresses_for_env.bastion.vpc.values.tags
}

resource "aws_vpc" "poc" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr_block           = var.ip_addresses_for_env.poc.vpc.values.cidr_block
  tags                 = var.ip_addresses_for_env.poc.vpc.values.tags
}

resource "aws_internet_gateway" "web_app" {
  tags = {
    Name = "Web App VPC Internet Gateway"
  }
}

resource "aws_internet_gateway" "poc" {
  tags = {
    Name = "Proof of Concept VPC Internet Gateway"
  }
}

resource "aws_vpn_gateway" "bastion" {
  tags = {
    Name = "Mock VPN Gateway"
  }
}

resource "aws_internet_gateway_attachment" "web_app" {
  internet_gateway_id = aws_internet_gateway.web_app.id
  vpc_id              = aws_vpc.web_app.id
}


resource "aws_internet_gateway_attachment" "poc" {
  internet_gateway_id = aws_internet_gateway.poc.id
  vpc_id              = aws_vpc.poc.id
}

resource "aws_vpn_gateway_attachment" "bastion" {
  vpn_gateway_id = aws_vpn_gateway.bastion.id
  vpc_id         = aws_vpc.bastion.id
}

resource "aws_vpc_peering_connection" "web_app_to_bastion_peer" {
  peer_vpc_id = aws_vpc.bastion.id
  vpc_id      = aws_vpc.web_app.id
}

resource "aws_vpc_peering_connection" "poc_to_bastion_peer" {
  peer_vpc_id = aws_vpc.bastion.id
  vpc_id      = aws_vpc.poc.id
}

resource "aws_subnet" "web_app_public_az1" {
  vpc_id                  = aws_vpc.web_app.id
  map_public_ip_on_launch = var.ip_addresses_for_env.web_app.vpc.values.map_public_ip_on_launch
  cidr_block              = var.ip_addresses_for_env.web_app.vpc.values.public_subnet_az1
  availability_zone       = element(data.aws_availability_zones.available_zones.names, 0)
  tags = {
    Name = "Web App Public Subnet in AZ1"
  }
}

resource "aws_subnet" "web_app_web_az1" {
  vpc_id                  = aws_vpc.web_app.id
  map_public_ip_on_launch = var.ip_addresses_for_env.web_app.vpc.values.map_public_ip_on_launch
  cidr_block              = var.ip_addresses_for_env.web_app.vpc.values.web_subnet_az1
  availability_zone       = element(data.aws_availability_zones.available_zones.names, 0)
  tags = {
    Name = "Web App Subnet in AZ1"
  }
}

resource "aws_subnet" "web_app_db_az1" {
  vpc_id                  = aws_vpc.web_app.id
  map_public_ip_on_launch = var.ip_addresses_for_env.web_app.vpc.values.map_public_ip_on_launch
  cidr_block              = var.ip_addresses_for_env.web_app.vpc.values.db_subnet_az1
  availability_zone       = element(data.aws_availability_zones.available_zones.names, 0)
  tags = {
    Name = "Web App DB Subnet in AZ1"
  }
}

resource "aws_subnet" "web_app_public_az2" {
  vpc_id                  = aws_vpc.web_app.id
  map_public_ip_on_launch = var.ip_addresses_for_env.web_app.vpc.values.map_public_ip_on_launch
  cidr_block              = var.ip_addresses_for_env.web_app.vpc.values.public_subnet_az2
  availability_zone       = element(data.aws_availability_zones.available_zones.names, 1)
  tags = {
    Name = "Web App Public Subnet in AZ2"
  }
}

resource "aws_subnet" "web_app_web_az2" {
  vpc_id                  = aws_vpc.web_app.id
  map_public_ip_on_launch = var.ip_addresses_for_env.web_app.vpc.values.map_public_ip_on_launch
  cidr_block              = var.ip_addresses_for_env.web_app.vpc.values.web_subnet_az2
  availability_zone       = element(data.aws_availability_zones.available_zones.names, 1)
  tags = {
    Name = "Web App Subnet in AZ2"
  }
}

resource "aws_subnet" "web_app_db_az2" {
  vpc_id                  = aws_vpc.web_app.id
  map_public_ip_on_launch = var.ip_addresses_for_env.web_app.vpc.values.map_public_ip_on_launch
  cidr_block              = var.ip_addresses_for_env.web_app.vpc.values.db_subnet_az2
  availability_zone       = element(data.aws_availability_zones.available_zones.names, 0)
  tags = {
    Name = "Web App DB Subnet in AZ2"
  }
}

resource "aws_subnet" "web_bastion_public_az1" {
  vpc_id                  = aws_vpc.bastion.id
  map_public_ip_on_launch = var.ip_addresses_for_env.bastion.vpc.values.map_public_ip_on_launch
  cidr_block              = var.ip_addresses_for_env.bastion.vpc.values.public_subnet_az1
  availability_zone       = element(data.aws_availability_zones.available_zones.names, 0)
  tags = {
    Name = "Bastion Subnet in AZ1"
  }
}

resource "aws_subnet" "web_bastion_public_az2" {
  vpc_id                  = aws_vpc.bastion.id
  map_public_ip_on_launch = var.ip_addresses_for_env.bastion.vpc.values.map_public_ip_on_launch
  cidr_block              = var.ip_addresses_for_env.bastion.vpc.values.public_subnet_az2
  availability_zone       = element(data.aws_availability_zones.available_zones.names, 0)
  tags = {
    Name = "Bastion Subnet in AZ2"
  }
}

resource "aws_subnet" "poc_public_az1" {
  vpc_id                  = aws_vpc.poc.id
  map_public_ip_on_launch = true
  cidr_block              = var.ip_addresses_for_env.poc.vpc.values.public_subnet_az1
  availability_zone       = element(data.aws_availability_zones.available_zones.names, 0)
  tags = {
    Name = "Proof of Concept Public Subnet in AZ1"
  }
}

resource "aws_subnet" "poc_private_az1" {
  vpc_id                  = aws_vpc.poc.id
  map_public_ip_on_launch = var.ip_addresses_for_env.poc.vpc.values.map_public_ip_on_launch
  cidr_block              = var.ip_addresses_for_env.poc.vpc.values.private_subnet_az1
  availability_zone       = element(data.aws_availability_zones.available_zones.names, 0)
  tags = {
    Name = "Proof of Concept Private Subnet in AZ1"
  }
}

resource "aws_subnet" "poc_public_az2" {
  vpc_id                  = aws_vpc.poc.id
  map_public_ip_on_launch = true
  cidr_block              = var.ip_addresses_for_env.poc.vpc.values.public_subnet_az2
  availability_zone       = element(data.aws_availability_zones.available_zones.names, 1)
  tags = {
    Name = "Proof of Concept Public Subnet in AZ2"
  }
}

resource "aws_subnet" "poc_private_az2" {
  vpc_id                  = aws_vpc.poc.id
  map_public_ip_on_launch = var.ip_addresses_for_env.poc.vpc.values.map_public_ip_on_launch
  cidr_block              = var.ip_addresses_for_env.poc.vpc.values.private_subnet_az2
  availability_zone       = element(data.aws_availability_zones.available_zones.names, 1)
  tags = {
    Name = "Proof of Concept Private Subnet in AZ2"
  }
}

resource "aws_eip" "web_app_az1" {
  domain = "vpc"
}

resource "aws_nat_gateway" "web_app_az1" {
  allocation_id = aws_eip.web_app_az1.allocation_id
  subnet_id     = aws_subnet.web_app_public_az1.id
}

resource "aws_route_table" "web_app_public" {
  vpc_id = aws_vpc.web_app.id
  tags = {
    Name = "Web App VPC Public Route Table"
  }
}

resource "aws_route" "web_app_ig" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web_app.id
  route_table_id         = aws_route_table.web_app_public.id
}

resource "aws_route" "web_app_public_peering" {
  destination_cidr_block    = var.ip_addresses_for_env.bastion.vpc.values.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.web_app_to_bastion_peer.id
  route_table_id            = aws_route_table.web_app_public.id
}

resource "aws_route_table" "web_app_private" {
  vpc_id = aws_vpc.web_app.id
  tags = {
    Name = "Web App VPC Private Route Table"
  }
}

resource "aws_route" "web_app_private_peering" {
  destination_cidr_block    = var.ip_addresses_for_env.bastion.vpc.values.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.web_app_to_bastion_peer.id
  route_table_id            = aws_route_table.web_app_private.id
}

resource "aws_route" "web_app_private_nat" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.web_app_az1.id
  route_table_id         = aws_route_table.web_app_private.id
}

resource "aws_route_table_association" "web_app_public_az1" {
  route_table_id = aws_route_table.web_app_public.id
  subnet_id      = aws_subnet.web_app_public_az1.id
}

resource "aws_route_table_association" "web_app_public_az2" {
  route_table_id = aws_route_table.web_app_public.id
  subnet_id      = aws_subnet.web_app_public_az2.id
}

resource "aws_route_table_association" "db_public_az1" {
  route_table_id = aws_route_table.web_app_public.id
  subnet_id      = aws_subnet.web_app_db_az1.id
}

resource "aws_route_table_association" "db_public_az2" {
  route_table_id = aws_route_table.web_app_public.id
  subnet_id      = aws_subnet.web_app_db_az2.id
}

resource "aws_route_table_association" "web_app_az1" {
  route_table_id = aws_route_table.web_app_private.id
  subnet_id      = aws_subnet.web_app_web_az1.id
}

resource "aws_route_table_association" "web_app_az2" {
  route_table_id = aws_route_table.web_app_private.id
  subnet_id      = aws_subnet.web_app_web_az2.id
}

resource "aws_route_table" "bastion_private" {
  vpc_id = aws_vpc.bastion.id
  tags = {
    Name = "Bastion VPC Private Route Table"
  }
}

resource "aws_route" "bastion_private_on_prem" {
  destination_cidr_block = var.ip_addresses_for_env.bastion.vpc.values.on_prem_cidr_block
  gateway_id             = aws_vpn_gateway.bastion.id
  route_table_id         = aws_route_table.bastion_private.id
}

resource "aws_route" "bastion_private_peering" {
  destination_cidr_block    = var.ip_addresses_for_env.web_app.vpc.values.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.web_app_to_bastion_peer.id
  route_table_id            = aws_route_table.bastion_private.id
}

resource "aws_route_table_association" "bastion_private_az1" {
  route_table_id = aws_route_table.bastion_private.id
  subnet_id      = aws_subnet.web_bastion_public_az1.id
}

resource "aws_route_table_association" "bastion_private_az2" {
  route_table_id = aws_route_table.bastion_private.id
  subnet_id      = aws_subnet.web_bastion_public_az2.id
}

resource "aws_route_table" "poc_public" {
  vpc_id = aws_vpc.poc.id
  tags = {
    Name = "Proof of Concept VPC Public Route Table"
  }
}

resource "aws_route" "poc_ig" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.poc.id
  route_table_id         = aws_route_table.poc_public.id
}

resource "aws_route" "poc_public_peering" {
  destination_cidr_block    = var.ip_addresses_for_env.bastion.vpc.values.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.poc_to_bastion_peer.id
  route_table_id            = aws_route_table.poc_public.id
}

resource "aws_route_table" "poc_private" {
  vpc_id = aws_vpc.poc.id
  tags = {
    Name = "Proof of Concept VPC Private Route Tablee"
  }
}

resource "aws_route" "poc_private_peering" {
  destination_cidr_block    = var.ip_addresses_for_env.bastion.vpc.values.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.poc_to_bastion_peer.id
  route_table_id            = aws_route_table.poc_private.id
}

resource "aws_route_table_association" "poc_public_az1" {
  route_table_id = aws_route_table.poc_public.id
  subnet_id      = aws_subnet.poc_public_az1.id
}

resource "aws_route_table_association" "poc_public_az2" {
  route_table_id = aws_route_table.poc_public.id
  subnet_id      = aws_subnet.poc_public_az2.id
}

resource "aws_route_table_association" "poc_private_az1" {
  route_table_id = aws_route_table.poc_private.id
  subnet_id      = aws_subnet.poc_private_az1.id
}

resource "aws_route_table_association" "poc_private_az2" {
  route_table_id = aws_route_table.poc_private.id
  subnet_id      = aws_subnet.poc_private_az2.id
}

resource "aws_security_group" "web_app_lb_sg" {
  name        = "WebApp Application Load Balancer Security Group"
  description = "Opens HTTP for Load Balancer to the Internet"
  vpc_id      = aws_vpc.web_app.id

  ingress = [
    {
      protocol  = "tcp"
      from_port = 80
      to_port   = 80
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    }
  ]
}

resource "aws_security_group" "web_app_server_sg" {
  name        = "WebApp Web Server Security Group"
  description = "Opens HTTP for Web Servers to Load Balancer"
  vpc_id      = aws_vpc.web_app.id

  ingress = [
    {
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_blocks = []
      security_groups = [
        aws_security_group.web_app_lb_sg.id
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      ipv6_cidr_blocks = []
    },
    {
      protocol  = "tcp"
      from_port = 22
      to_port   = 22
      cidr_blocks = [
        aws_vpc.bastion.cidr_block
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    },
    {
      protocol  = "tcp"
      from_port = 3389
      to_port   = 3389
      cidr_blocks = [
        aws_vpc.bastion.cidr_block
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    }
  ]
}

resource "aws_vpc_security_group_egress_rule" "web_app_lb_to_server" {
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

  security_group_id            = aws_security_group.web_app_lb_sg.id
  referenced_security_group_id = aws_security_group.web_app_server_sg.id
}

resource "aws_security_group" "db_server_sg" {
  name        = "WebApp Database Server Security Group"
  description = "Opens mysql (3306) port for Database Servers to Web Servers"
  vpc_id      = aws_vpc.web_app.id

  ingress = [
    {
      protocol  = "tcp"
      from_port = 3306
      to_port   = 3306

      cidr_blocks = [
        "0.0.0.0/0"
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    },
    {
      protocol  = "tcp"
      from_port = 22
      to_port   = 22
      cidr_blocks = [
        aws_vpc.bastion.cidr_block
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    },
    {
      protocol  = "tcp"
      from_port = 3389
      to_port   = 3389
      cidr_blocks = [
        aws_vpc.bastion.cidr_block
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    }
  ]
}

resource "aws_security_group" "bastion_server_sg" {
  name        = "Bastion Server Security Group"
  description = "Opens SSH and RDP ports inbound and outbound"
  vpc_id      = aws_vpc.bastion.id

  ingress = [
    {
      protocol  = "tcp"
      from_port = 22
      to_port   = 22
      cidr_blocks = [
        var.ip_addresses_for_env.bastion.vpc.values.on_prem_cidr_block
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    },
    {
      protocol  = "tcp"
      from_port = 3389
      to_port   = 3389
      cidr_blocks = [
        var.ip_addresses_for_env.bastion.vpc.values.on_prem_cidr_block
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    }
  ]

  egress = [
    {
      protocol  = "tcp"
      from_port = 22
      to_port   = 22
      cidr_blocks = [
        var.ip_addresses_for_env.web_app.vpc.values.cidr_block
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    },
    {
      protocol  = "tcp"
      from_port = 3389
      to_port   = 3389
      cidr_blocks = [
        var.ip_addresses_for_env.web_app.vpc.values.cidr_block
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    }
  ]
}

resource "aws_security_group" "poc_server_az1" {
  name        = "PoC Web Server Security Group for AZ1"
  description = "Opens HTTP for Proof of Concept Web Servers in AZ1 to the internet"
  vpc_id      = aws_vpc.poc.id

  ingress = [
    {
      protocol  = "tcp"
      from_port = 80
      to_port   = 80
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      security_groups  = []
      self             = false
      description      = ""
      prefix_list_ids  = []
      ipv6_cidr_blocks = []
    },
    {
      protocol  = "tcp"
      from_port = 22
      to_port   = 22
      cidr_blocks = [
        aws_vpc.bastion.cidr_block
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    },
    {
      protocol  = "tcp"
      from_port = 3389
      to_port   = 3389
      cidr_blocks = [
        aws_vpc.bastion.cidr_block
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    }
  ]
}

resource "aws_security_group" "poc_server_az2" {
  name        = "PoC Web Server Security Group for AZ2"
  description = "Opens HTTP for Proof of Concept Web Servers in AZ2 to the internet"
  vpc_id      = aws_vpc.poc.id

  ingress = [
    {
      protocol  = "tcp"
      from_port = 443
      to_port   = 443
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      security_groups  = []
      self             = false
      description      = ""
      prefix_list_ids  = []
      ipv6_cidr_blocks = []
    },
    {
      protocol  = "tcp"
      from_port = 22
      to_port   = 22
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    },
    {
      protocol  = "tcp"
      from_port = 3389
      to_port   = 3389
      cidr_blocks = [
        aws_vpc.bastion.cidr_block
      ]
      self             = false
      description      = ""
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    }
  ]
}

data "aws_iam_policy_document" "shared_service_connectivity" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "shared_service_connectivity" {
  name                = "SharedServerConnectivityRole"
  assume_role_policy  = data.aws_iam_policy_document.shared_service_connectivity.json
  managed_policy_arns = [aws_iam_policy.shared_server_connectivity.arn]
}

resource "aws_iam_instance_profile" "shared_service_connectivity" {
  name = "SharedServerConnectivityRole"
  role = aws_iam_role.shared_service_connectivity.name
}

resource "aws_iam_policy" "shared_server_connectivity" {
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "s3:GetEncryptionConfiguration",
        Resource = "*"
      }
  ] })
}

data "aws_ami" "latest_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer"
  public_key = file("${path.module}/key.pub")
}

resource "aws_instance" "web_app_server_az1" {
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  ami           = data.aws_ami.latest_linux.id

  iam_instance_profile = aws_iam_instance_profile.shared_service_connectivity.name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web_app_server_az1.id
  }

  user_data = <<-EOF
					#!/bin/bash -xe"
					sudo yum update -y
					wget https://inspector-agent.amazonaws.com/linux/latest/install
					sudo bash install
					sudo yum install httpd -y
					sudo systemctl start httpd
					sudo systemctl restart rsyslog
          EOF
  tags = {
    Name                    = "Web Server for AZ1"
    NetworkReachabilityDemo = "True"
  }
}

resource "aws_network_interface" "web_app_server_az1" {
  subnet_id       = aws_subnet.web_app_web_az1.id
  security_groups = [aws_security_group.web_app_server_sg.id]
}

resource "aws_instance" "web_app_server_az2" {
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  ami           = data.aws_ami.latest_linux.id

  iam_instance_profile = aws_iam_instance_profile.shared_service_connectivity.name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web_app_server_az2.id
  }

  user_data = <<-EOF
					#!/bin/bash -xe"
					sudo yum update -y
					wget https://inspector-agent.amazonaws.com/linux/latest/install
					sudo bash install
					sudo yum install httpd -y
					sudo systemctl start httpd
					sudo systemctl restart rsyslog
          EOF
  tags = {
    Name                    = "Web Server for AZ2"
    NetworkReachabilityDemo = "True"
  }
}

resource "aws_network_interface" "web_app_server_az2" {
  subnet_id       = aws_subnet.web_app_web_az2.id
  security_groups = [aws_security_group.web_app_server_sg.id]
}

resource "aws_instance" "web_db_server_az1" {
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  ami           = data.aws_ami.latest_linux.id

  iam_instance_profile = aws_iam_instance_profile.shared_service_connectivity.name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web_db_server_az1.id
  }

  user_data = <<-EOF
					#!/bin/bash -xe"
					sudo yum update -y
					wget https://inspector-agent.amazonaws.com/linux/latest/install
					sudo bash install
					wget https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
					sudo yum install mysql80-community-release-el7-1.noarch.rpm -y
					sudo yum install mysql-community-server -y
					sudo service mysqld start
					sudo systemctl restart rsyslog
          EOF
  tags = {
    Name                    = "Database Server for AZ1"
    NetworkReachabilityDemo = "True"
  }
}

resource "aws_network_interface" "web_db_server_az1" {
  subnet_id       = aws_subnet.web_app_db_az1.id
  security_groups = [aws_security_group.db_server_sg.id]
}

resource "aws_instance" "web_db_server_az2" {
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  ami           = data.aws_ami.latest_linux.id

  iam_instance_profile = aws_iam_instance_profile.shared_service_connectivity.name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web_db_server_az2.id
  }

  user_data = <<-EOF
					#!/bin/bash -xe"
					sudo yum update -y
					wget https://inspector-agent.amazonaws.com/linux/latest/install
					sudo bash install
					wget https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
					sudo yum install mysql80-community-release-el7-1.noarch.rpm -y
					sudo yum install mysql-community-server -y
					sudo service mysqld start
					sudo systemctl restart rsyslog
          EOF
  tags = {
    Name                    = "Database Server for AZ2"
    NetworkReachabilityDemo = "True"
  }
}

resource "aws_network_interface" "web_db_server_az2" {
  subnet_id       = aws_subnet.web_app_db_az2.id
  security_groups = [aws_security_group.db_server_sg.id]
}

resource "aws_instance" "bastion_az1" {
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  ami           = data.aws_ami.latest_linux.id

  iam_instance_profile = aws_iam_instance_profile.shared_service_connectivity.name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.bastion_az1.id
  }

  user_data = <<-EOF
					#!/bin/bash -xe"
					sudo yum update -y
					wget https://inspector-agent.amazonaws.com/linux/latest/install
					sudo bash install
          EOF
  tags = {
    Name                    = "Bastion Server for AZ1"
    NetworkReachabilityDemo = "True"
  }
}

resource "aws_network_interface" "bastion_az1" {
  subnet_id       = aws_subnet.web_bastion_public_az1.id
  security_groups = [aws_security_group.bastion_server_sg.id]
}

resource "aws_instance" "bastion_az2" {
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  ami           = data.aws_ami.latest_linux.id

  iam_instance_profile = aws_iam_instance_profile.shared_service_connectivity.name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.bastion_az2.id
  }

  user_data = <<-EOF
					#!/bin/bash -xe"
					sudo yum update -y
					wget https://inspector-agent.amazonaws.com/linux/latest/install
					sudo bash install
          EOF
  tags = {
    Name                    = "Bastion Server for AZ2"
    NetworkReachabilityDemo = "True"
  }
}

resource "aws_network_interface" "bastion_az2" {
  subnet_id       = aws_subnet.web_bastion_public_az2.id
  security_groups = [aws_security_group.bastion_server_sg.id]
}

resource "aws_instance" "poc_server_az1" {
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  ami           = data.aws_ami.latest_linux.id

  iam_instance_profile = aws_iam_instance_profile.shared_service_connectivity.name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.poc_server_az1.id
  }

  user_data = <<-EOF
					#!/bin/bash -xe"
					sudo yum update -y
					wget https://inspector-agent.amazonaws.com/linux/latest/install
					sudo bash install
          sudo yum install httpd -y
					sudo systemctl start httpd
					wget https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
					sudo yum install mysql80-community-release-el7-1.noarch.rpm -y
					sudo yum install mysql-community-server -y
					sudo service mysqld start
					sudo systemctl restart rsyslog
          EOF
  tags = {
    Name                    = "PoC Web Server for AZ1"
    NetworkReachabilityDemo = "True"
  }
}

resource "aws_network_interface" "poc_server_az1" {
  subnet_id       = aws_subnet.poc_public_az1.id
  security_groups = [aws_security_group.poc_server_az1.id]
}

resource "aws_instance" "poc_server_az2" {
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  ami           = data.aws_ami.latest_linux.id

  iam_instance_profile = aws_iam_instance_profile.shared_service_connectivity.name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.poc_server_az2.id
  }

  user_data = <<-EOF
					#!/bin/bash -xe"
					sudo yum update -y
					wget https://inspector-agent.amazonaws.com/linux/latest/install
					sudo bash install
          sudo yum install httpd -y
					sudo systemctl start httpd
					wget https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
					sudo yum install mysql80-community-release-el7-1.noarch.rpm -y
					sudo yum install mysql-community-server -y
					sudo service mysqld start
					sudo systemctl restart rsyslog
          EOF
  tags = {
    Name                    = "PoC Web Server for AZ2"
    NetworkReachabilityDemo = "True"
  }
}

resource "aws_network_interface" "poc_server_az2" {
  subnet_id       = aws_subnet.poc_public_az1.id
  security_groups = [aws_security_group.poc_server_az1.id]
}

resource "aws_lb" "web_app" {
  name            = "WebAppLoadBalancer"
  security_groups = [aws_security_group.web_app_lb_sg.id]
  subnets         = [aws_subnet.web_app_public_az1.id, aws_subnet.web_app_public_az2.id]
  tags = {
    Name                    = "NetworkReachabilityDemo"
    NetworkReachabilityDemo = "True"
  }
}

resource "aws_lb_target_group_attachment" "web_app_z1" {
  target_group_arn = aws_lb_target_group.web_app.arn
  target_id        = aws_instance.web_app_server_az1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_app_z2" {
  target_group_arn = aws_lb_target_group.web_app.arn
  target_id        = aws_instance.web_app_server_az2.id
  port             = 80
}

resource "aws_lb_target_group" "web_app" {
  name     = "WebServerTargetGroup"
  vpc_id   = aws_vpc.web_app.id
  protocol = "HTTP"
  port     = 80

  health_check {
    interval = 60
    port     = 80
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "web_app" {
  load_balancer_arn = aws_lb.web_app.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app.arn
  }
}

resource "aws_sns_topic" "inspector" {
  name         = "InspectorAutomation"
  display_name = "InspectorAutomation"
}

data "aws_iam_policy_document" "inspector" {
  policy_id = "InspectorTopicPolicy"
  statement {
    sid    = "owner-policy-statement"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "SNS:Publish",
      "SNS:RemovePermission",
      "SNS:SetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:Receive",
      "SNS:AddPermission",
      "SNS:Subscribe"
    ]

    resources = [
      aws_sns_topic.inspector.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values = [
        local.AccountId
      ]
    }
  }

  statement {
    sid    = "Statement10001"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["inspector.amazonaws.com"]
    }
    actions = ["sns:Publish"]
    resources = [
      aws_sns_topic.inspector.arn
    ]
  }
}

resource "aws_sns_topic_policy" "inspector" {
  arn    = aws_sns_topic.inspector.arn
  policy = data.aws_iam_policy_document.inspector.json
}

data "archive_file" "lambda" {
  type        = "zip"
  output_path = "${path.module}/.terraform/lambda.zip"
  source {
    filename = "index.py"
    content  = <<-EOF
import boto3
import json
import logging

inspector = boto3.client('inspector')
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):

 logger.debug('Raw Lambda event:')
 logger.debug(event)

 # extract the message that Inspector sent via SNS
 message = event['Records'][0]['Sns']['Message']
 logger.debug('Event from SNS: ' + message)

 # get inspector notification type
 notificationType = json.loads(message)['event']
 logger.info('Inspector SNS message type: ' + notificationType)

 # skip everything except report_finding notifications
 if notificationType != \"FINDING_REPORTED\":
  logger.info('Skipping notification that is not a new finding: ' + notificationType)
  return 1

 # extract finding ARN
 findingArn = json.loads(message)['finding']
 logger.info('Finding ARN: ' + findingArn)

 # get finding and extract detail
 response = inspector.describe_findings(findingArns = [ findingArn ])
 logger.debug('Inspector DescribeFindings response:')
 logger.debug(response)
 finding = response['findings'][0]
 logger.debug('Raw finding:')
 logger.debug(finding)

 # skip uninteresting findings
 title = finding['title']
 logger.debug('Finding title: ' + title)

 if title == \"Unsupported Operating System or Version\":
  logger.info('Skipping finding: ' + title)
  return 1

 if title == \"No potential security issues found\":
  logger.info('Skipping finding: ' + title)
  return 1

 service = finding['service']
 logger.debug('Service: ' + service)
 if service != \"Inspector\":
  logger.info('Skipping finding from service: ' + service)
  return 1

 #Look for the Internet Accessible Instances with SSH open
 reachabilityPort = \"\"
 naclToChange = \"\"
 findingId =  finding['id']
 if findingId == \"Recognized port with listener reachable from internet\":
  logger.info('Found open port to the World - Inspector finding')
  for attribute in finding['attributes']:
   if attribute['key'] == \"PORT\":
    reachabilityPort = attribute['value']
    if reachabilityPort != \"22\":
     logger.info('Found port' + reachabilityPort + 'open to the internet')
     return 1
   if attribute['key'] == \"ACL\":
    naclToChange = attribute['value']
  if reachabilityPort != \"\" and naclToChange != \"\":
   # Setup a NACL to deny inbound and outbound port 22 from all IP from this subnet
   ec2 = boto3.client('ec2')
   response = ec2.create_network_acl_entry(
   DryRun=False,
   Egress=False,
   NetworkAclId=naclToChange,
   CidrBlock=\"0.0.0.0/0\",
   Protocol=\"6\",
   PortRange={
    'From':22,
    'To':22
   },
   RuleAction='deny',
   RuleNumber=90
   )
   print(\"log -- Event: NACL Deny Rule for Recognized port with listener reachable from internet\")
 else:
  print(\"log -- Event without defined action. No action taken.\")
  return 1
 return response
    EOF
  }
}

resource "aws_lambda_function" "remediation_nacl" {
  function_name    = "NetworkReachabilityDemo-remediation-nacl"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  handler          = "index.handler"
  runtime          = "python3.10"
  timeout          = "35"
  role             = aws_iam_role.remediation.arn
}

data "aws_iam_policy_document" "remediation" {
  statement {
    effect = "Allow"
    actions = [
      "inspector:ListRulesPackages",
      "inspector:StartAssessmentRun",
      "inspector:SubscribeToEvent",
      "inspector:SetTagsForResource",
      "inspector:Describe*",
      "ec2:CreateTags",
      "ec2:Describe*",
      "ec2:*NetworkAcl*",
      "iam:CreateServiceLinkedRole"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "remediation" {
  name                = "NetworkReachabilityDemo-lambda-remediation"
  assume_role_policy  = data.aws_iam_policy_document.remediation-sts.json
  path                = "/"
  managed_policy_arns = [aws_iam_policy.remediation.arn]
}

resource "aws_iam_policy" "remediation" {
  name   = "remediation-64343"
  policy = data.aws_iam_policy_document.remediation.json
}

data "aws_iam_policy_document" "remediation-sts" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_lambda_permission" "remediation" {
  statement_id  = "AllowExecution"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.remediation_nacl.function_name
  principal     = "events.amazonaws.com"
}