module "network" {
  source = "./modules/network"
  server_name = var.server_name
  datacenter = var.datacenter
  ip_type = var.ip_type
}

module "dns" {
  source = "./modules/dns"
  domain = var.domain
  porkbun_nameservers = var.porkbun_nameservers
  cloudflare_zone_id = data.hcp_vault_secrets_secret.cloudflare_zone_id.secret_value
  static_ip = module.network.static_ip
}

module "compute" {
  source = "./modules/compute"
  server_name = var.server_name
  os_image = var.os_image
  server_type = var.server_type
  datacenter = var.datacenter
  ansible_user = var.ansible_user
  ansible_user_ssh_key = var.ansible_user_ssh_key
  personal_user = var.personal_user
  workflow_id = var.workflow_id
  repo_name = var.repo_name
  github_pa_token = data.hcp_vault_secrets_secret.github_pa_token.secret_value
  primary_ip_id = module.network.primary_ip_id
  firewall_id = module.network.firewall_id
  tailscale_ip = var.tailscale_ip
  tailscale_tailnet_key = data.hcp_vault_secrets_secret.tailscale_auth_token.secret_value
  #tailscale_tailnet_key = module.auth.tailscale_tailnet_key
  tailscale_api_token = data.hcp_vault_secrets_secret.tailscale_api_key.secret_value
}

module "auth" {
  source = "./modules/auth"
  tailscale_tailnet = var.tailscale_tailnet
  server_name = var.server_name
}