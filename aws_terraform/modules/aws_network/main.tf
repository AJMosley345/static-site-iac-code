# Creates the VPC for all of the resources to connect within
resource "aws_vpc" "am_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name    = "vpc"
      Module  = "aws_network"
      VPC     = var.vpc_name
    }
  )
}

# Creates a local variable for the VPC id to make it more easily reusable
locals {
  vpc_id = aws_vpc.am_vpc.id
}

# Creates the public subnet
resource "aws_subnet" "am_public_subnet" {
  vpc_id                  = local.vpc_id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name    = "public_subnet"
      Module  = "aws_network"
      VPC     = var.vpc_name
    }
  )
}

# Creates the private subnet
resource "aws_subnet" "am_private_subnet" {
  vpc_id     = local.vpc_id
  cidr_block = var.private_subnet_cidr

  tags = merge(
    var.tags,
    {
      Name    = "private_subnet"
      Module  = "aws_network"
      VPC     = var.vpc_name
    }
  )
}

# Creates an internet gateway for the VPC to allow internet access to the resources inside
resource "aws_internet_gateway" "am_internet_gateway" {
  vpc_id = local.vpc_id

  tags = merge(
    var.tags,
    {
      Name    = "internet_gateway"
      Module  = "aws_network"
      VPC     = var.vpc_name
    }
  )
}

# Creates a route table for the public subnet
resource "aws_route_table" "am_public_route_table" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.am_internet_gateway.id
  }

  tags = merge(
    var.tags,
    {
      Name    = "public_route_table"
      Module  = "aws_network"
      VPC     = var.vpc_name
    }
  )
}

# Creates an association between the route table and the public subnet
resource "aws_route_table_association" "am_public_route_table_association" {
  subnet_id      = aws_subnet.am_public_subnet.id
  route_table_id = aws_route_table.am_public_route_table.id
}

# Creates the security group to control the ports that are open to the VPC
resource "aws_security_group" "am_security_group" {
  vpc_id = local.vpc_id

  ingress {
    from_port   = 41641
    to_port     = 41641
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name    = "security_group"
      Module  = "aws_network"
      VPC     = var.vpc_name
    }
  )
}