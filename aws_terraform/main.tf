module "aws_dns" {
  source      = "./modules/aws_dns"
  domain_name = var.domain_name
  static_ip   = var.current_static_ip
  tags        = var.tags
}

module "aws_iam" {
  source    = "./modules/aws_iam"
  iam_roles = var.iam_roles
  tags      = var.tags
}

module "aws_lambda" {
  source             = "./modules/aws_lambda"
  # Lambda Function
  source_file_name   = var.source_file_name
  function_name      = var.function_name
  role_arn           = module.aws_iam.role_arns
  github_webhook_url = var.github_webhook_url
  github_pa_token    = var.github_pa_token
  
  # EventBridge Rule
  event_rule_name        = var.event_rule_name
  event_rule_description = var.event_rule_description
  event_pattern          = var.event_pattern
  event_target_id        = var.event_target_id
  server_name            = var.instance_name 
  # Lambda Permission
  statement_id             = var.lambda_permission_statement_id
  lambda_permission_action = var.lambda_permission_action
  principal                = var.lambda_permission_principal

  tags = var.tags
}

module "aws_network" {
  source                     = "./modules/aws_network"
  vpc_name                   = var.vpc_name
  vpc_cidr                   = var.vpc_cidr
  public_subnet_cidr         = var.public_subnet_cidr
  private_subnet_cidr        = var.private_subnet_cidr
  security_group_name        = var.security_group_name
  security_group_description = var.security_group_description
  ingress_rules              = var.ingress_rules
  tags                       = var.tags
}

module "aws_vm" {
  source                 = "./modules/aws_vm"
  bucket_name            = var.bucket_name
  channel_name           = var.channel_name
  region                 = var.region
  instance_type          = var.instance_type
  instance_name          = var.instance_name
  subnet_id              = module.aws_network.public_subnet_id
  vpc_security_group_id  = module.aws_network.security_group_id
  tailscale_auth_key     = var.tailscale_auth_key
  tags                   = var.tags
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
