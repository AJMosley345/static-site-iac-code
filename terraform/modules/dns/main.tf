# Sets nameservers of my domain to point to Cloudflare's on Porkbun
resource "porkbun_nameservers" "cloudflare_nameservers" {
  domain = var.domain
  nameservers = var.porkbun_nameservers
}

# Creates a new DNS A record in Cloudflare to point the domain to the created server and it's ip.
resource "cloudflare_dns_record" "static_site_record" {
  zone_id = var.cloudflare_zone_id
  name = var.domain
  content = var.static_ip
  type = "A"
  ttl = 1
  comment = "Static site record for server hosted on Hetzner"
  proxied = true
}

# resource "cloudflare_dns_record" "wildcard_record" {
#   zone_id = var.cloudflare_zone_id
#   name = format("%s.%s", "*", var.domain)
#   content = var.domain
#   type = "CNAME"
#   ttl = 1
#   comment = format("%s %s", "Wildcard record for domain", var.domain)
#   proxied = true
# }
# resource "cloudflare_dns_record" "www_record" {
#   zone_id = var.cloudflare_zone_id
#   name = format("%s.%s", "www", var.domain)
#   content = var.domain
#   type = "CNAME"
#   ttl = 1
#   comment = format("%s %s", "WWW record for domain", var.domain)
#   proxied = true
# }

resource "cloudflare_dns_record" "netlify_cname_record" {
  zone_id = var.cloudflare_zone_id
  name  = "@"
  content = var.netlify_address
  type = "CNAME"
  ttl = 1
  comment = format("%s %s", "Root CNAME record for Netlify", var.domain)
  proxied = false
}

resource "cloudflare_dns_record" "netlify_www_cname_record" {
  zone_id = var.cloudflare_zone_id
  name = format("%s.%s", "www", var.domain)
  content = var.netlify_address
  type = "CNAME"
  ttl = 1
  comment = format("%s %s", "Root CNAME record for Netlify", var.domain)
  proxied = false
}