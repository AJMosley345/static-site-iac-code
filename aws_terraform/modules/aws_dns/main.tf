# Creates the Public DNS zone for the domain
resource "aws_route53_zone" "main_domain_zone" {
  provider    = aws
  name        = var.domain_name
  tags = merge(
    var.tags,
    {
      Name    = "main_domain_zone"
      Module  = "aws_dns"
      Domain  = var.domain_name
    }
  )
}
# Creates the appropriate records 
resource "aws_route53_record" "aws_webserver_record" {
  provider        = aws
  zone_id         = aws_route53_zone.main_domain_zone.zone_id
  name            = var.domain_name
  type            = "A"
  ttl             = 86400
  records         = [ var.static_ip ]
}

# CNAME Record for www Subdomain
resource "aws_route53_record" "aws_www_cname_record" {
  provider        = aws
  zone_id         = aws_route53_zone.main_domain_zone.zone_id
  name            = "www.${var.domain_name}"
  type            = "CNAME"
  ttl             = 86400
  records         = [var.domain_name] # Points to the root domain
}

# Wildcard CNAME Record for All Subdomains
resource "aws_route53_record" "aws_wildcard_cname_record" {
  provider        = aws
  zone_id         = aws_route53_zone.main_domain_zone.zone_id
  name            = "*.${var.domain_name}"
  type            = "CNAME"
  ttl             = 86400
  records         = [var.domain_name] # Points to the root domain
}