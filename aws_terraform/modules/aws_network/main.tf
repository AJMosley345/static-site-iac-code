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

# Creates the public subnet
resource "aws_subnet" "am_public_subnet" {
  vpc_id                  = aws_vpc.am_vpc.id
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
  vpc_id     = aws_vpc.am_vpc.id
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
  vpc_id = aws_vpc.am_vpc.id

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
  vpc_id = aws_vpc.am_vpc.id

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
  vpc_id      = aws_vpc.am_vpc.id
  description = var.security_group_description
  name        = var.security_group_name

  lifecycle {
      create_before_destroy = true
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


# Creates the ingress rules to add to the security group
resource "aws_vpc_security_group_ingress_rule" "ingress_rules" {
  security_group_id = aws_security_group.am_security_group.id

  for_each = { for rule in var.ingress_rules : rule.name => rule }

  cidr_ipv4   = each.value.ipv4
  from_port   = each.value.port
  ip_protocol = each.value.protocol
  to_port     = each.value.to_port
  tags = merge(
    var.tags,{
      Name   = "ingress_rule"
      Module = "aws_network"
      VPC    = var.vpc_name
    }
  )
}

# Egress rule for the security group to allow all traffic out from the VPC
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.am_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  tags = merge(
    var.tags, {
      Name   = "egress_rule"
      Module = "aws_network"
      VPC    = var.vpc_name
    }
  )
}