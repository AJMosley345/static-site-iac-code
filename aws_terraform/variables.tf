# S3 Bucket Backend Variables
variable "s3_bucket_config" {
  type = object({
    bucket         = string
    key            = string
    region         = string
    dynamodb_table = string
  })
}

# AWS Route 53 Varaibles (aws_dns)
variable "domain_name" {
  description = "Domain name (i.e. google.com)"
  type        = string
}

# AWS IAM Variables (aws_iam)
variable "iam_roles" {
  description = "List of IAM roles with policies"
  type = list(object({
    name               = string
    assume_role_policy = string
    policies = list(object({
      policy_name = string
      description = string
      policy      = string
    }))
  }))
}

# AWS Lambda Variables (aws_lambda)
variable "function_name" {
  description = "Name of the lambda function"
  type        = string
}

variable "source_file_name" {
  description = "Name of the source file to use in the Lambda function. Should be in the aws_lambda module"
  type        = string
}

variable "github_webhook_url" {
  description = "URL of my github webhook to trigger the workflow"
  type        = string
}

variable "github_pa_token" {
  description = "Personal Access Token to trigger the workflow"
  type        = string
}

# AWS Cloudwatch Variables (aws_lambda)
variable "event_rule_name" {
  description = "Name of the CloudWatch Event Rule"
  type        = string
}

variable "event_rule_description" {
  description = "Description of the Event Rule"
  type        = string
  default     = "Triggers an event when conditions are met"
}

variable "event_pattern" {
  description = "JSON Event Pattern to trigger the rule"
  type        = string
}

variable "event_target_id" {
  description = "Identifier for the EventBridge rule target"
  type        = string
}

variable "lambda_permission_statement_id" {
  description = "ID for the Lambda permission"
  type        = string
}

variable "lambda_permission_action" {
  description = "The Lambda action that is being granted by the statement"
  type        = string
}

variable "lambda_permission_principal" {
  description = "The principal that the permission is being granted to"
  type        = string
}

# AWS Network Variables (aws_network)
variable "create_instance" {
  description = "Controls the creation of instances while I'm testing"
  type        = bool
}
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
variable "security_group_name" {
  description = "Name to give the security group in the VPC"
  type        = string
}
variable "security_group_description" {
  description = "Description of the security group"
  type        = string
}
variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    name     = string  # Unique name for the rule (used in for_each)
    ipv4     = string  # CIDR block for allowed IPs
    port     = number  # Starting port
    to_port  = number  # Ending port
    protocol = string  # Protocol (tcp, udp, etc.)
  }))
}

# AWS VM Variables (aws_vm)
variable "bucket_name" {
  description = "Name of the Packer bucket"
  type        = string
}
variable "channel_name" {
  description = "Name of the image channel in the Packer bucket"
  type        = string
}
variable "region" {
  description = "Region that the AMI is stored in"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
}

variable "tailscale_auth_key" {
  description = "Auth key to allow auto approval to Tailscale network"
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