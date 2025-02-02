# Creates the Public DNS zone for the domain
resource "aws_route53_zone" "main_domain_zone" {
  name = var.domain_name

  tags = {
    "Name" = var.domain_name,
    "Purpose" = "Webserver"
  }
}

# Requests a certficate for the domain
resource "aws_acm_certificate" "aws_domain_cert_request" {
  domain_name = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}", "www.${var.domain_name}"]
  validation_method = "DNS"

  tags = {
    "Name" = var.domain_name,
    "Purpose" = "Webserver"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Creates a validation record for the request to verify the domain
resource "aws_route53_record" "aws_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.aws_domain_cert_request.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  zone_id         = aws_route53_zone.main_domain_zone.zone_id
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
}

# "Waits" for the certificate to be issued
resource "aws_acm_certificate_validation" "aws_cert_validation" {
  certificate_arn = aws_acm_certificate.aws_domain_cert_request.arn
  validation_record_fqdns = [for record in aws_route53_record.aws_validation_record : record.fqdn]
}

# Creates the appropriate records 
resource "aws_route53_record" "aws_webserver_record" {
  allow_overwrite = true
  zone_id = aws_route53_zone.main_domain_zone.zone_id
  name = var.domain_name
  type = "A"
  ttl = 86400
  records = [ var.static_ip ]
}
# CNAME Record for www Subdomain
resource "aws_route53_record" "aws_www_cname_record" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.main_domain_zone.zone_id
  name            = "www.${var.domain_name}"
  type            = "CNAME"
  ttl             = 300
  records         = [var.domain_name] # Points to the root domain
}

# Wildcard CNAME Record for All Subdomains
resource "aws_route53_record" "aws_wildcard_cname_record" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.main_domain_zone.zone_id
  name            = "*.${var.domain_name}"
  type            = "CNAME"
  ttl             = 300
  records         = [var.domain_name] # Points to the root domain
}

# Sets nameservers of the domain on Porkbun to point to the AWS Zone
resource "porkbun_nameservers" "porkbun_nameservers" {
  domain = var.domain_name
  nameservers = [
    "anderson.ns.cloudflare.com",
    "evelyn.ns.cloudflare.com",
    aws_route53_zone.main_domain_zone.name_servers[0],
    aws_route53_zone.main_domain_zone.name_servers[1],
    aws_route53_zone.main_domain_zone.name_servers[2],
    aws_route53_zone.main_domain_zone.name_servers[3]
  ]
}