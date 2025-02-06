# S3 Bucket Backend Variables
variable "s3_bucket_config" {
  type = object({
    bucket         = string
    key            = string
    region         = string
    dynamodb_table = string
  })
}

# AWS Route 53/Porkbun Variables
variable "domain_name" {
  description = "Domain name (i.e. google.com)"
  type        = string
}

# Tailscale Variables
variable "tailscale_tailnet" {
  description = "Tailnet for the Tailscale account"
  type        = string
}
variable "tailscale_tag" {
  description = "Tag to auto apply to devices authorized with the created Tailscale auth token"
  type        = string
}
variable "tailscale_acls" {
  description = "HuJSON style ACLs for Tailscale"
  type        = string 
}
# Current static IP of my webserver
variable "current_static_ip" {
  description = "Current static IP of my webserver"
  type        = string
}

# AWS Variables
variable "tags" {
  description = "Base tags to apply to all resources"
  type        = map(string)
}


# AWS Network Variables
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}
variable "vpc_cidr" {
  description = "Value of the cidr block to give the VPC"
  type        = string
}
variable "public_subnet_cidr" {
  description = "Value of the cidr block to give the public subnet in the VPC"
  type        = string
}
variable "private_subnet_cidr" {
  description = "Value of the cidr block to give the private subnet in the VPC"
  type        = string
}
