variable "hcp_sp_client_id" {
  type = string
  sensitive = true
}
variable "hcp_sp_client_secret" {
  type = string
  sensitive = true
}
variable "hcp_app_name" {
  type = string
  default = "amosley-static-site-iac"
}
variable "domain" {
  type = string
}
variable "repo_name" {
  description = "Name of the repo to use the command on in the form of repo/your-repo"
  type = string
}