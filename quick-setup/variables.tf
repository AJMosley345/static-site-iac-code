# HCP Variables
variable "hcp_sp_client_id" {
  type = string
  sensitive = true
}
variable "hcp_sp_client_secret" {
  type = string
  sensitive = true
}
variable "hcp_app_name" {
  description = "Name of the hcp app to access vault secrets from"
  type = string
  default = "amosley-static-site-iac"
}

# Hetzner Variables
variable "server_name" {
  description = "Name of the server"
  type = string
  default = "am-static-site"
}
variable "datacenter" {
  description = "Name of the datacenter to host the server at"
  type = string
  default = "ash-dc1"
}
variable "server_type" {
  description = "Type of server to create"
  type = string
  default = "cpx11"
}
variable "os_image" {
  description = "OS image to use"
  type = string
  default = "ubuntu-24.04"
}

# Tailscale Variables
variable "tailscale_tailnet" {
  type = string
  default = "tailc67af.ts.net"
}