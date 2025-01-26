# Hetzner Variables
variable "server_name" {
  description = "Name of the server"
  type = string
}
variable "datacenter" {
  description = "Name of the datacenter to host the server at"
  type = string
}
variable "ip_type" {
  description = "Type of IP address to create (ipv4 or ipv6)"
  type = string
}