output "role_arns" {
  description = "Map of IAM role names to their ARNs"
  value       = { for role_name, role in aws_iam_role.iam_roles : role_name => role.arn }
}