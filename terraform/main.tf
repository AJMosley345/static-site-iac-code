# Sets nameservers of my domain to point to Cloudflare's on Porkbun
resource "porkbun_nameservers" "cloudflare_nameservers" {
  domain = var.domain
  nameservers = var.porkbun_nameservers
}

# Provisions a server in Hetzner cloud, and gives it a primary ip to be passed to Cloudflare. Also creates an ssh key resource
locals {
  ssh_files = fileset(".ssh/", "*.pub")
  ssh_keys = { for file in local.ssh_files : file => {
      name = replace(file, ".pub", "")
      public_key = file(".ssh/${file}")
    }
  }
}

resource "hcloud_ssh_key" "keys" {
  for_each = local.ssh_keys

  name       = each.value.name
  public_key = each.value.public_key
}

resource "hcloud_primary_ip" "am_static_site_ip" {
  name = var.server_name
  datacenter = var.datacenter
  type = var.ip_type
  assignee_type = "server"
  auto_delete = false
}

# Get github personal access token from HCP Vault Secrets to use in the cloud init
data "hcp_vault_secrets_secret" "github_pa_token" {
  app_name = var.hcp_app_name
  secret_name = "github_pa_token"
}
locals {
  ssh_key_name = format("%s_%s", "hetzner", var.ansible_user)
  ansible_ssh_key = hcloud_ssh_key.keys[local.ssh_key_name].public_key
}
data "template_cloudinit_config" "cloud_config" {
  part {
    filename = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content = file("cloud-init/cloud-init.yml")
  }
}


resource "hcloud_server" "am_static_site" {
  name = var.server_name
  image = var.os_image
  server_type = var.server_type
  datacenter = var.datacenter
  user_data = data.template_cloudinit_config.cloud_config.rendered
  ssh_keys = [ for key in hcloud_ssh_key.keys : key.name  ]
  labels = {
    "role" : "webserver",
    "ssh_ip": hcloud_primary_ip.am_static_site_ip.ip_address
  }
  public_net {
    ipv4 = hcloud_primary_ip.am_static_site_ip.id
  }
}

data "hcp_vault_secrets_secret" "cloudflare_zone_id" {
  app_name = var.hcp_app_name
  secret_name = "cloudflare_zone_id"
}

# Creates a new DNS A record in Cloudflare to point the domain to the created server and it's ip, then creates two CNAME records for the wildcard domain and www domain.
resource "cloudflare_dns_record" "static_site_record" {
  zone_id = data.hcp_vault_secrets_secret.cloudflare_zone_id.secret_value
  name = var.domain
  content = hcloud_primary_ip.am_static_site_ip.ip_address
  type = "A"
  ttl = 1
  comment = "Static site record for server hosted on Hetzner"
  proxied = true
}
resource "cloudflare_dns_record" "wildcard_record" {
  zone_id = data.hcp_vault_secrets_secret.cloudflare_zone_id.secret_value
  name = format("%s.%s", "*", var.domain)
  content = var.domain
  type = "CNAME"
  ttl = 1
  comment = format("%s %s", "Wildcard record for domain", var.domain)
  proxied = true
}
resource "cloudflare_dns_record" "www_record" {
  zone_id = data.hcp_vault_secrets_secret.cloudflare_zone_id.secret_value
  name = format("%s.%s", "www", var.domain)
  content = var.domain
  type = "CNAME"
  ttl = 1
  comment = format("%s %s", "WWW record for domain", var.domain)
  proxied = true
}
