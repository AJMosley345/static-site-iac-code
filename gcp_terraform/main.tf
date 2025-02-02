module "network" {
  source        = "./modules/network"
  server_name   = var.server_name
  region        = var.region
  allowed_ports = var.allowed_ports
}

module "dns" {
  source              = "./modules/dns"
  domain_name         = var.domain_name
  porkbun_nameservers = var.porkbun_nameservers
  static_ip           = module.network.static_ip
}

module "compute" {
  source       = "./modules/compute"
  # Server creation variables
  server_name  = var.server_name
  zone         = var.zone
  machine_type = var.machine_type
  os_image     = var.os_image
  static_ip    = module.network.static_ip
  gsa_email    = google_service_account.static_site_sa.email

  # Startup Script Variables
  ansible_user_ssh_key = var.ansible_user_ssh_key
  personal_user        = var.personal_user
  tailscale_auth_key   = module.auth.tailscale_tailnet_key
  github_pa_token      = var.github_pa_token
  repo_name            = var.repo_name
}

module "tailscale" {
  source            = "./modules/tailscale"
  tailscale_tailnet = var.tailscale_tailnet
  server_name       = var.server_name
  tailscale_tag     = var.tailscale_tag
}