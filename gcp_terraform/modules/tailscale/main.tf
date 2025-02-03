# Creates an an auth key at Tailscale and gives it a tag for servers
# resource "tailscale_tailnet_key" "webserver_key" {
#   provider = tailscale
#   description = "Key for GCP. Auto applys the needed tag"
#   reusable = true
#   ephemeral = false
#   preauthorized = true
#   expiry = 7776000
#   tags = [var.tailscale_tag]
# }

# Blank resource to import acls
resource "tailscale_acl" "acls" {
  provider = tailscale
  acl = file("${path.module}/acls.txt")
}