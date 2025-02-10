# Creates an an auth key at Tailscale and gives it a tag for servers
resource "tailscale_tailnet_key" "webserver_key" {
  description   = "Key for AWS"
  reusable      = true
  ephemeral     = true
  preauthorized = true
  expiry        = 7776000
  tags          = [var.tailscale_tag]
}

resource "tailscale_acl" "acls" {
  acl = var.tailscale_acls
}