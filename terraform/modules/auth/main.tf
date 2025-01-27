# Creates an an auth key at Tailscale and gives it a tag for servers
resource "tailscale_tailnet_key" "webserver_key" {
  description = "Key for webserver to more securely access it"
  reusable = true
  ephemeral = false
  preauthorized = true
  expiry = 7776000
  tags = [ "tag:webserver" ]
}