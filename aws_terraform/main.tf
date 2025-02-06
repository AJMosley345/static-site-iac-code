module "aws_dns" {
  source      = "./modules/aws_dns"
  domain_name = var.domain_name
  static_ip   = var.current_static_ip
  tags        = var.tags
}

module "aws_network" {
  source              = "./modules/aws_network"
  vpc_name            = var.vpc_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  tags                = var.tags
}

module "aws_vm" {
  source = "./modules/aws_vm"
}

module "porkbun" {
  source       = "./modules/porkbun"
  domain_name  = var.domain_name
  name_servers = module.aws_dns.aws_domain_zone_name_servers
}

module "tailscale" {
  source            = "./modules/tailscale"
  tailscale_tailnet = var.tailscale_tailnet
  tailscale_tag     = var.tailscale_tag
  tailscale_acls    = var.tailscale_acls
}
