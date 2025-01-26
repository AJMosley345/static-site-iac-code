# Cloud-Init Variables
variable "repo_name" {
  description = "Name of the repo to use the command on in the form of repo/your-repo"
  type = string
}
variable "workflow_id" {
  description = "ID of the workflow to trigger at the end of cloud-init"
  type = string
}
variable "github_pa_token" {}

# Hetzner Variables
variable "server_name" {
  description = "Name of the server"
  type = string
}
variable "datacenter" {
  description = "Name of the datacenter to host the server at"
  type = string
}
variable "server_type" {
  description = "Type of server to create"
  type = string
}
variable "os_image" {
  description = "OS image to use"
  type = string
}
variable "ansible_user" {
  description = "The name of the user whose SSH key will be added to the Cloud-Init configuration."
  type        = string
}
variable "personal_user" {
  description = "The name of the user who will be created by ansible"
  type        = string
}
variable "ansible_user_ssh_key" {
  description = "Public key content for the ansible user"
  type = string
}
variable "primary_ip_id" {
  description = "ID of the primary IP created by hcloud_primary_ip"
  type = string
}
variable "firewall_id" {
  description = "ID of the firewall created"
}
variable "tailscale_ip" {}
variable "tailscale_tailnet_key" {}