output "aws_domain_zone_name_servers" {
  value = aws_route53_zone.main_domain_zone.name_servers
}

output "aws_domain_zone_id" {
  value = aws_route53_zone.main_domain_zone.zone_id
}