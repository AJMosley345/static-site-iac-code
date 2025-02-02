#!/usr/bin/env python3
import json
import subprocess

# Fetch Tailscale status
tailscale_status_result = subprocess.run(["tailscale", "status", "--json"], capture_output=True, text=True)
tailscale_status = json.loads(tailscale_status_result.stdout)

# Targets the webserver tag to filter the inventory results
target_tag = "tag:gcp-webserver"

# Generate invetory
inventory = {
    "all": {
        "hosts": [],
        "vars": {}
    },
    "_meta": {
        "hostvars": {}
    }
}

for peer in tailscale_status.get("Peer", {}).values():
    hostname = peer.get("HostName")
    tailscale_ips = peer.get("TailscaleIPs", [])
    tags = peer.get("Tags", [])
    
    # Check if the device has the target tag
    if hostname and tailscale_ips and target_tag in tags:
        inventory["all"]["hosts"].append(hostname)
        inventory["_meta"]["hostvars"][hostname] = {
            "ansible_host": tailscale_ips[0]
        }
        
# Output inventory as JSON
print(json.dumps(inventory))