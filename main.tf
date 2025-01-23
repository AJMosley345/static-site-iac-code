# Sets nameservers of my domain to point to Cloudflare's on Porkbun
resource "porkbun_nameservers" "cloudflare_nameservers" {
  domain = "ajmosley.com"
  nameservers = [ 
    "evelyn.ns.cloudflare.com",
    "anderson.ns.cloudflare.com"
   ]
}

# Provisions a server in Hetzner cloud and gives it a primary ip
resource "hcloud_primary_ip" "main" {
  name = "primary_ip"
  datacenter = "us-east"
  type = "ipv4"
  assignee_type = "server"
  auto_delete = true
}
resource "hcloud_server" "static_site" {
  name = "static-site"
  image = "ubuntu-24.04"
  server_type = "cpx11"
  datacenter = "us-east"
  public_net {
    ipv4 = hcloud_primary_ip.main.id
  }
}

data "hcp_vault_secrets_secret" "cloudflare_zone_id" {
  app_name = var.hcp_app_name
  secret_name = "cloudflare_zone_id"
}

# Creates a new DNS record in Cloudflare for the created server and it's ip
resource "cloudflare_dns_record" "static_site_record" {
  zone_id = data.hcp_vault_secrets_secret.cloudflare_zone_id.secret_value
  name = "ajmosley.com"
  content = hcloud_primary_ip.main.ip_address
  type = "A"
  ttl = 3600
  comment = "Static site record for server hosted on Hetzner"
  proxied = true
}
