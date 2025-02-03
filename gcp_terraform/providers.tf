terraform {
  cloud {
    organization = "AJMosley"
    workspaces {
      name = "Static-Site-GCP"
    }
  }
  required_version = ">= 1.1.0"
  required_providers {
    porkbun = {
      source = "kyswtn/porkbun"
      version = ">= 0.1.3"
    }
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.84.0"
    }
    google = {
      source = "hashicorp/google"
      version = ">= 6.18.1"
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = ">= 0.17.2"
    }
    hcp = {
      source = "hashicorp/hcp"
      version = ">= 0.102.0"
    }
  }
}

# Providers are getting the appropriate variables through HCP Vault Secrets and Terraform integration.
provider "hcp" {}
# Getting the dynamic secret from HCP Vault Secrets
data "hcp_vault_secrets_dynamic_secret" "gcp_dynamic_secret" {
  app_name    = var.tf_app_name
  secret_name = var.secret_name
}
# Uses the dynamic secret from HVS to authenticate with the needed permissions to create the resources
# provider "google" {
#   alias        = "dynamic_secret"
#   access_token = data.hcp_vault_secrets_dynamic_secret.gcp_dynamic_secret.secret_values["access_token"]
#   zone         = var.zone
# }
provider "porkbun" {}
provider "tailscale" {}
provider "aws" {
  region = var.aws_region
}
