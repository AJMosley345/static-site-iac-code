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
      version = "0.1.3"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.84.0"
    }
    google = {
      source = "hashicorp/google"
      version = "6.18.1"
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.17.2"
    }
  }
}

# Providers are getting the appropriate variables through HCP Vault Secrets and Terraform integration.
provider "porkbun" {
  api_key = var.porkbun_api_key
  secret_api_key = var.porkbun_secret_api_key
}
provider "google" {}
provider "tailscale" {}
provider "aws" {}

# Creates a custom google service account just for creating the resources
resource "google_service_account" "static_site_sa" {
  account_id = "static-site-sa"
  display_name = "Static Site Service Account"
}