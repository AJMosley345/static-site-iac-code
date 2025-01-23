terraform {
  required_providers {
    porkbun = {
      source = "kyswtn/porkbun"
      version = "0.1.3"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "5.0.0-rc1"
    }
    hcp = {
      source = "hashicorp/hcp"
      version = "0.101.0"
    }
  }
}

provider "hcp" {
  client_id = var.hcp_sp_client_id
  client_secret = var.hcp_sp_client_secret
}
# Get secret variables from vault
data "hcp_vault_secrets_app" "vault" {
  app_name = var.hcp_app_name
}

# Get porkbun secret variables then authenticate
data "hcp_vault_secrets_secret" "porkbun_secret_key" {
  app_name = var.hcp_app_name
  secret_name = "porkbun_secret_key"
}
data "hcp_vault_secrets_secret" "porkbun_api_key" {
  app_name = var.hcp_app_name
  secret_name = "porkbun_api_key"
}
provider "porkbun" {
  api_key        = data.hcp_vault_secrets_secret.porkbun_api_key.secret_value
  secret_api_key = data.hcp_vault_secrets_secret.porkbun_secret_key.secret_value
}

# Get Cloudflare secret variable then authenticate
data "hcp_vault_secrets_secret" "cloudflare_api_token" {
  app_name = var.hcp_app_name
  secret_name = "cloudflare_api_token"
}
provider "cloudflare" {
  api_token = data.hcp_vault_secrets_secret.cloudflare_api_token.secret_value
}

# Get Hetzner secret variable then authenticate
data "hcp_vault_secrets_secret" "hetzner_api_key" {
  app_name = var.hcp_app_name
  secret_name = "hetzner_api_key"
}
provider "hcloud" {
  token = data.hcp_vault_secrets_secret.hetzner_api_key.secret_value

}
