terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

variable "api_token"{}

variable "zone_id"{}

provider "cloudflare" {
  api_token = var.api_token
}

resource "cloudflare_record" "lightsail_instance" {
    zone_id = var.zone_id
    name    = "ajmosley.com"
    content   = "100.29.71.200"
    type    = "A"
    proxied = true
}