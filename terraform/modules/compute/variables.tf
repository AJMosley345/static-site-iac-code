# Cloud-Init Variables
variable "repo_name" {}
variable "workflow_id" {}
variable "github_pa_token" {}
variable "tailscale_auth_key" {}
variable "tailscale_ip" {}
variable "tailscale_api_key" {}
variable "personal_user" {}
variable "ansible_user_ssh_key" {}

# Hetzner Variables
variable "server_name" {}
variable "datacenter" {}
variable "server_type" {}
variable "os_image" {}
variable "primary_ip_id" {}
variable "firewall_id" {}