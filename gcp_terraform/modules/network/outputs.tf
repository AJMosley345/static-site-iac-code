output "static_ip" {
  value = google_compute_address.static_ip.address
}

output "firewall_name" {
  value = google_compute_firewall.static_site_firewall.name
}

output "firewall_rules" {
  description = "The firewall rules applied to the network."
  value       = var.allowed_ports
}
