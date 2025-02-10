output "aws_route53_nameservers" {
  description = "Namservers of my Route 53 domain"
  value       = module.aws_dns.aws_domain_zone_name_servers
}

output "vpc_id" {
  value = module.aws_network.vpc_id
}

output "public_subnet_id" {
  value = module.aws_network.public_subnet_id
}
output "private_subnet_id" {
  value = module.aws_network.private_subnet_id
}
output "security_group_id" {
  value = module.aws_network.security_group_id
}