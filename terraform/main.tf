# Sets nameservers of my domain to point to Cloudflare's on Porkbun
resource "porkbun_nameservers" "cloudflare_nameservers" {
  domain = "ajmosley.com"
  nameservers = [ 
    "evelyn.ns.cloudflare.com",
    "anderson.ns.cloudflare.com"
   ]
}

# Provisions a server in Hetzner cloud, and gives it a primary ip to be passed to Cloudflare. Also creates an ssh key resource
resource "hcloud_ssh_key" "aj_local_machine" {
  name = "aj_local_machine"
  public_key = file("./.ssh/hetzner_local_machine.pub")
}

resource "hcloud_ssh_key" "ansible" {
  name = "ansible"
  public_key = file("./.ssh/hetzner_ansible.pub")
}

resource "hcloud_primary_ip" "am_static_site_ip" {
  name = "am_static_site"
  datacenter = "ash-dc1"
  type = "ipv4"
  assignee_type = "server"
  auto_delete = false
}

# Get github personal access token from HCP Vault Secrets to use in the cloud init
data "hcp_vault_secrets_secret" "github_pa_token" {
  app_name = var.hcp_app_name
  secret_name = "github_pa_token"
}

resource "hcloud_server" "am_static_site" {
  name = "am-static-site"
  image = "ubuntu-24.04"
  server_type = "cpx11"
  datacenter = "ash-dc1"
  user_data = <<-EOT
#cloud-config
# Creates the users amosley and ansible. amosley for admin tasks and ansible to run the ansible playbooks to fully setup the server
users:
  - name: amosley
    groups: users, admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF1TzYGftp6/UvRnOZ0GKUg9nPF9pkaaeXbc+QbPQiI2 aj@amosley-desktop
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDe1r5rFEsOT7NsRhfmouf5VaPeujou+l9/zbcDjVmSCBuBuucRNcDS4isbG143+eOTxGNTT8Jqqr1BZi8rTf63sBSuGGU1NKv/FB+hTE+P7aMFsncRS313OqhBwCvAb7CB0QEHfBntNpVVIkpLcIS+JUWINd7CGLbDKr9PPAiT7OAnNeLkAI9OiRXARIsQdeg/VKVtd+G8lJ/FOsCT+RGsEUZO6Qw83W1j5QoOIMzFWDRwpRitHuz/VLwTuMa0hKNbVumR86RX8H+BGkl52Kio2buJoySqQiYsaqKy7vrguna3MwWWPj3dBexGPEBYI6GOhnq2LEx+hBh0y8L8rodBGWkfl4co1dTXIyAif0gAenXA2UJHVhDk6r8/1umYfOH6+bUKtnub4hRjepsCLXQSn3rnx1r5Hez0QzX/HVr8CdvHtBghYE598aeXwpDG+78JrBQCNr55bzPL6VV065kYV6tqYeJsAN+YnK+Rqqk9tOKWlN27KhnXBNhb8pYNl04A5sfodYh0xlo9ScGbMrlXqSnqhtzDK36clfe1oY9qR1utsQ6HwSOfbPUjsBwHJ35dvp4bcsT9GB8j0gOd8+vc7B0+H4HW19LNi/D8rJ29GeecG3sWxcs/Vmf96O4G4/CrANK9tDevtDuHGbWPOl8kOx3uD9/wylitdK1KBqVatw== amosley@am-static-site
  - name: ansible
    groups: users, admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINLo35q0WX/c3ulmxvLo8A9j2pmZHxIZiDwxYWQVaRib ansible@am-static-site

# Trigger webhook to GitHub Actions after setup
runcmd:
  - curl -X POST -H "Content-Type: application/json" \
      -d '{"status": "ready"}' \
      https://api.github.com/${var.repo_name}/actions/workflows/bootstrap.yml/dispatches \
      -H "Authorization: token ${data.hcp_vault_secrets_secret.github_pa_token.secret_value}"
EOT

  ssh_keys = [ hcloud_ssh_key.aj_local_machine.id, hcloud_ssh_key.ansible.id  ]
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
  name = "*.ajmosley.com"
  content = var.domain
  type = "CNAME"
  ttl = 1
  comment = format("%s %s", "Wildcard record for domain", var.domain)
  proxied = true
}
resource "cloudflare_dns_record" "www_record" {
  zone_id = data.hcp_vault_secrets_secret.cloudflare_zone_id.secret_value
  name = "www.ajmosley.com"
  content = var.domain
  type = "CNAME"
  ttl = 1
  comment = format("%s %s", "WWW record for domain", var.domain)
  proxied = true
}
