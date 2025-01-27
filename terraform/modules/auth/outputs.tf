output "webserver_tailscale_ip" {
  value = data.tailscale_device.webserver.addresses[0]
}
output "tailscale_tailnet_key" {
  value = tailscale_tailnet_key.webserver_key.key
}