terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

variable "api_token"{
    type = string
}

variable "zone_id"{
    type = string
}

provider "cloudflare" {
  api_token = var.api_token
}


resource "cloudflare_record" "www" {
    zone_id = var.zone_id
    name    = "testing"
    content   = "10.0.0.1"
    type    = "A"
    proxied = true
}