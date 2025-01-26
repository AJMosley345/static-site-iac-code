output "hcloud_server_resource" {
  description = "hcloud server resource to pass to depends on"
  value = hcloud_server.am_static_site
}