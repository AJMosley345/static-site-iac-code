data "google_project" "project_id" {
  provider = google
}
module "aws" {
  source      = "./modules/aws"
  domain_name = var.domain_name
  static_ip   = var.current_static_ip
}

module "gcp" {
  source = "./modules/gcp"
  # Server creation variables
  server_name          = var.server_name
  zone                 = var.zone
  machine_type         = var.machine_type
  os_image             = var.os_image
  allowed_ports        = var.allowed_ports
  project_id           = data.google_project.project_id.id

  # Startup Script Variables
  ansible_user_ssh_key = var.ansible_user_ssh_key
  personal_user        = var.personal_user
  tailscale_auth_key   = var.tailscale_auth_key
  github_pa_token      = var.github_pa_token
  repo_owner           = var.repo_owner
  repo_name            = var.repo_name
}

module "porkbun" {
  source       = "./modules/porkbun"
  domain_name  = var.domain_name
  name_servers = module.aws.aws_domain_zone_name_servers
}

module "tailscale" {
  source            = "./modules/tailscale"
  tailscale_tailnet = var.tailscale_tailnet
  tailscale_tag     = var.tailscale_tag
}
