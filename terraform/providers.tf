terraform {
  cloud {
    organization = "AJMosley"
    workspaces {
      name = "static-site-iac-code"
    }
  }
  required_version = ">= 1.1.0"
  required_providers {
    porkbun = {
      source = "kyswtn/porkbun"
      version = "0.1.3"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "5.0.0-rc1"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.17.2"
    }
    hcp = {
      source = "hashicorp/hcp"
      version = "0.101.0"
    }
  }
}

# Authenticate to HCP Vault
provider "hcp" {
  client_id = var.hcp_sp_client_id
  client_secret = var.hcp_sp_client_secret
}

# Get secret variables from vault
data "hcp_vault_secrets_secret" "github_pa_token" {
  app_name = var.hcp_app_name
  secret_name = "github_pa_token"
}

data "hcp_vault_secrets_secret" "porkbun_secret_key" {
  app_name = var.hcp_app_name
  secret_name = "porkbun_secret_key"
}

data "hcp_vault_secrets_secret" "porkbun_api_key" {
  app_name = var.hcp_app_name
  secret_name = "porkbun_api_key"
}

data "hcp_vault_secrets_secret" "cloudflare_api_token" {
  app_name = var.hcp_app_name
  secret_name = "cloudflare_api_token"
}

data "hcp_vault_secrets_secret" "cloudflare_zone_id" {
  app_name = var.hcp_app_name
  secret_name = "cloudflare_zone_id"
}

data "hcp_vault_secrets_secret" "hetzner_api_key" {
  app_name = var.hcp_app_name
  secret_name = "hetzner_api_key"
}

data "hcp_vault_secrets_secret" "tailscale_api_key" {
  app_name = var.hcp_app_name
  secret_name = "tailscale_api_key"
}

# Authenticate to each provider with the secrets
provider "porkbun" {
  api_key        = data.hcp_vault_secrets_secret.porkbun_api_key.secret_value
  secret_api_key = data.hcp_vault_secrets_secret.porkbun_secret_key.secret_value
}

provider "cloudflare" {
  api_token = data.hcp_vault_secrets_secret.cloudflare_api_token.secret_value
}

provider "hcloud" {
  token = data.hcp_vault_secrets_secret.hetzner_api_key.secret_value
}

provider "tailscale" {
  api_key = data.hcp_vault_secrets_secret.tailscale_api_key.secret_value
  tailnet = var.tailscale_tailnet
}