# Cloudflare/Porkbun Variables
variable "domain_name" {
  description = "Domain name (i.e. google.com)"
  type = string
}
variable "porkbun_nameservers" {
  description = "Nameservers to point Porkbun domain to"
  type = list(string)
  default = [ 
    "evelyn.ns.cloudflare.com",
    "anderson.ns.cloudflare.com"
  ]
}
variable "cloudflare_zone_id" {}

# Cloud-Init Variables
variable "repo_name" {
  description = "Name of the repo to use the command on in the form of repo/your-repo"
  type = string
}
variable "workflow_id" {
  description = "ID of the workflow to trigger at the end of cloud-init"
  type = string
}
variable "personal_user" {
  description = "The name of the user who will be created by ansible"
  type        = string
}
variable "ansible_user_ssh_key" {
  description = "Public key content for the ansible user"
  type = string
}
variable "tailscale_ip" {
  type = string
}
variable "github_pa_token" {}
variable "tailscale_api_key" {}
variable "tailscale_auth_key" {}

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

# Tailscale Variables
variable "tailscale_tailnet" {
  type = string
}