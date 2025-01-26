terraform {
  required_version = ">= 1.1.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    hcp = {
      source = "hashicorp/hcp"
      version = "0.101.0"
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.17.2"
    }
  }
}

# Authenticate to HCP Vault
provider "hcp" {
  client_id = var.hcp_sp_client_id
  client_secret = var.hcp_sp_client_secret
}

# Get secret variables from vault
data "hcp_vault_secrets_secret" "hetzner_api_key" {
  app_name = var.hcp_app_name
  secret_name = "hetzner_api_key"
}

data "hcp_vault_secrets_secret" "tailscale_api_key" {
  app_name = var.hcp_app_name
  secret_name = "tailscale_api_key"
}

# Authenticate to each provider with the secrets
provider "hcloud" {
  token = data.hcp_vault_secrets_secret.hetzner_api_key.secret_value
}

provider "tailscale" {
  api_key = data.hcp_vault_secrets_secret.tailscale_api_key.secret_value
  tailnet = var.tailscale_tailnet
}