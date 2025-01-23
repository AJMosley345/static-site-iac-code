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