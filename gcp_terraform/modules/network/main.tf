# Creates a static ip address for the cloud server
resource "google_compute_address" "static_ip" {
  name   = var.server_name
  region = var.region
}

# Sets up a firewall for the server that only allows traffic from Tailscale (41641), Port 80 and Port 443 (for website traffic)
resource "google_compute_firewall" "static_site_firewall" {
  name    = var.server_name
  network = "default"

  dynamic "allow" {
    for_each = var.allowed_ports
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  source_ranges = ["0.0.0.0/0"]
}