output "static_ip" {
  description = "Static IP address of the Hetzner primary IP"
  value = hcloud_primary_ip.am_static_site_ip.ip_address
}
output "primary_ip_id" {
  description = "ID of the Hetzner primary IP"
  value = hcloud_primary_ip.am_static_site_ip.id
}
output "firewall_id" {
  description = "ID of the Hetzner firewall"
  value = hcloud_firewall.am_static_site_firewall.id
}
