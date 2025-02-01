module "network" {
  source = "./modules/network"
  server_name = var.server_name
  datacenter = var.datacenter
  ip_type = var.ip_type
}

module "dns" {
  source = "./modules/dns"
  domain_name = var.domain_name
  porkbun_nameservers = var.porkbun_nameservers
  cloudflare_zone_id = var.cloudflare_zone_id
  static_ip = module.network.static_ip
}

module "compute" {
  source = "./modules/compute"
  # Server creation variables
  server_name = var.server_name
  os_image = var.os_image
  server_type = var.server_type
  datacenter = var.datacenter
  primary_ip_id = module.network.primary_ip_id
  firewall_id = module.network.firewall_id
  
  # Cloud-Init Variables
  ansible_user_ssh_key = var.ansible_user_ssh_key
  personal_user = var.personal_user
  workflow_id = var.workflow_id
  repo_name = var.repo_name
  github_pa_token = var.github_pa_token
  tailscale_ip = var.tailscale_ip
  tailscale_auth_key = var.tailscale_auth_key
  tailscale_api_token = var.tailscale_api_token
}

module "auth" {
  source = "./modules/auth"
  tailscale_tailnet = var.tailscale_tailnet
  server_name = var.server_name
}