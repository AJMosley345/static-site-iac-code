# Creates an an auth key at Tailscale and gives it a tag for servers
resource "tailscale_tailnet_key" "webserver_key" {
  description = "Key for GCP. Auto applys the gcp-webserver tag"
  reusable = true
  ephemeral = false
  preauthorized = true
  expiry = 7776000
  tags = [var.tailscale_tag]
}