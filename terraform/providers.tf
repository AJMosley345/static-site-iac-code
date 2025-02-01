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
    aws = {
      source = "hashicorp/aws"
      version = "5.84.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.17.2"
    }
  }
}

# Providers are getting the appropriate variables through HCP Vault Secrets and Terraform integration.
provider "porkbun" {}
provider "cloudflare" {}
provider "hcloud" {}
provider "tailscale" {}
provider "aws" {}