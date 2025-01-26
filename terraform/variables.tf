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
}

# Cloudflare/Porkbun Variables
variable "domain" {
  description = "Domain name (i.e. google.com)"
  type = string
}
variable "porkbun_nameservers" {
  description = "Nameservers to point Porkbun domain to"
  type = list(string)
}
# Cloud-Init Variables
variable "repo_name" {
  description = "Name of the repo to use the command on in the form of repo/your-repo"
  type = string
}
variable "workflow_id" {
  description = "ID of the workflow to trigger at the end of cloud-init"
  type = string
}

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
variable "ip_type" {
  description = "Type of IP address to create (ipv4 or ipv6)"
  type = string
}
variable "ssh_keys" {
  description = "SSH keys to create at Hetzner for access to the server"
  type = map(object({
    name = string
    public_key = string
  }))
}
variable "ansible_user" {
  description = "The name of the user whose SSH key will be added to the Cloud-Init configuration."
  type        = string
}
variable "personal_user" {
  description = "The name of the user who will be created by ansible"
  type        = string
}