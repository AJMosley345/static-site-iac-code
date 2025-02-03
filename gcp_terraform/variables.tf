# AWS Route 53/Porkbun Variables
variable "domain_name" {
  description = "Domain name (i.e. google.com)"
  type        = string
}
variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
}

# Startup Script Variables
variable "ansible_user_ssh_key" {
  description = "Public key content for the ansible user"
  type        = string
}
variable "personal_user" {
  description = "The name of the user who will be created by ansible"
  type        = string
}
variable "tailscale_auth_key" {
  description = "Stand in variable for the Tailscale auth key"
  type        = string
}
variable "github_pa_token" {
  description = "Stand in variable for the GitHub personal access token"
  type        = string
}
variable "repo_owner" {
  description = "Name of the repo owner"
  type = string
}
variable "repo_name" {
  description = "Name of the repo to use the command on in the form of repo/your-repo"
  type        = string
}

# GCP Variables
variable "project_name" {
  type = string
}
variable "server_name" {
  description = "Name of the server"
  type        = string
}
variable "zone" {
  description = "Name of the zone to host the server in"
  type        = string
}
variable "machine_type" {
  description = "Type of machine to create the server on"
  type        = string
}
variable "os_image" {
  description = "OS image to use"
  type        = string
}
variable "allowed_ports" {
  description = "Ports that are allowed by the firewall"
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
  default = [ 
    
  ]
}

# Tailscale Variables
variable "tailscale_tailnet" {
  description = "Tailnet for the Tailscale account"
  type = string
}
variable "tailscale_tag" {
  description = "Tag to auto apply to devices authorized with the created Tailscale auth token"
  type = string
}

# HCP Vault Secrets Variables
variable "tf_app_name" {
  type = string
}
variable "secret_name" {
  description = "Name of the secret to get from the app"
  type = string
}

# Current static IP of my webserver
variable "current_static_ip" {
  description = "Current static IP of my webserver"
  type = string
}