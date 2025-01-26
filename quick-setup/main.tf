# Creates an an auth key at Tailscale and gives it a tag for servers
data "hcloud_primary_ip" "primary_ip_id" {
  name = "am-static-site"
}

output "primary_ip_id2" {
  value = data.hcloud_primary_ip.primary_ip_id.id
}