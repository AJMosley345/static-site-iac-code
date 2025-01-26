# Creates an an auth key at Tailscale and gives it a tag for servers
resource "tailscale_tailnet_key" "webserver_key" {
  description = "Key for webserver to more securely access it"
  reusable = true
  ephemeral = false
  preauthorized = true
  expiry = 7776000
  tags = [ "tag:webserver" ]
}

resource "hcloud_server" "am_static_site" {
  name = var.server_name
  image = var.os_image
  server_type = var.server_type
  datacenter = var.datacenter
  user_data = <<EOT
#cloud-config

runcmd:
  - curl -fsSL https://tailscale.com/install.sh | sh
  - tailscale up --auth-key=${tailscale_tailnet_key.webserver_key.key}
EOT
  labels = {
    "role" : "webserver"
  }
}

data "tailscale_device" "webserver" {
  name    = format("%s.%s", hcloud_server.am_static_site.name, var.tailscale_tailnet)
}
output "tailscale_ip" {
  value = data.tailscale_device.webserver.id
}

