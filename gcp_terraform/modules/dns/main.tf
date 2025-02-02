# Creates the Public DNS zone for the domain
resource "aws_route53_zone" "main_domain_zone" {
  name = var.domain_name

  tags = {
    "Name" = var.domain_name,
    "Purpose" = "Webserver"
  }
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
  nameservers = concat(
    var.porkbun_nameservers,
    aws_route53_zone.main_domain_zone.name_servers
  )
}