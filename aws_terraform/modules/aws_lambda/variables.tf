# Lambda function
variable "function_name" {}
variable "role_arn" {}
variable "source_file_name" {}
variable "github_webhook_url" {}
variable "github_pa_token" {}

# Cloudwatch Variables
variable "event_rule_name" {}
variable "event_rule_description" {}
variable "event_pattern" {}
variable "event_target_id" {}
variable "statement_id" {}
variable "lambda_permission_action" {}
variable "principal" {}

variable "tags" {}