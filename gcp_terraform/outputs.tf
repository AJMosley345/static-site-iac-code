output "gcp_project_id" {
  description = "Project ID for my GCP project"
  value = data.google_project.project_id.id
}
output "aws_route53_nameservers" {
  description = "Namservers of my Route 53 domain"
  value = module.aws.aws_domain_zone_name_servers
}