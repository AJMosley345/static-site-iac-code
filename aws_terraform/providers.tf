terraform {
  backend "s3" {
    bucket         = var.s3_bucket_config.bucket
    key            = var.s3_bucket_config.key
    region         = var.s3_bucket_config.region
    dynamodb_table = var.s3_bucket_config.dynamodb_table
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
    tailscale = {
      source = "tailscale/tailscale"
      version = ">= 0.17.2"
    }
  }
}

# Providers are getting the appropriate configuration through environment variables
provider "porkbun" {}
provider "tailscale" {}
provider "aws" {}
