terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.66.0"
    }
  }
}
variable "access_key" {}
variable "secret_key" {}
provider "aws" {
  region = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_lightsail_instance" "ajmosley_static_site" {
    name = "amosley_static_site"
    availability_zone = "us-east-1a"
    blueprint_id = "ubuntu_22_04"
    bundle_id = "nano_3_0"
}