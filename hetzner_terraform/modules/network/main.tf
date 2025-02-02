# Creates a primary ip address for the cloud server
resource "hcloud_primary_ip" "am_static_site_ip" {
  name = var.server_name
  datacenter = var.datacenter
  type = var.ip_type
  assignee_type = "server"
  auto_delete = false
}

# Sets up a firewall for the server that only allows traffic from Tailscale (41641), Port 80 and Port 443 (for website traffic)
resource "hcloud_firewall" "am_static_site_firewall" {
  name = var.server_name
  rule {
    direction = "in"
    protocol = "udp"
    port = "41641"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}