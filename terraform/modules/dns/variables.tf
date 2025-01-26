# Cloudflare/Porkbun Variables
variable "domain" {
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
variable "static_ip" {
  description = "Static IP address of the server"
  type        = string
}
variable "cloudflare_zone_id" {}