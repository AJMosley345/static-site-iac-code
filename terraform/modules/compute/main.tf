# Creates ssh key resources for any ssh keys in .ssh/
locals {
  ssh_files = fileset(".ssh/", "*.pub")
  ssh_keys = { for file in local.ssh_files : file => {
      name = replace(file, ".pub", "")
      public_key = file(".ssh/${file}")
    }
  }
}

resource "hcloud_ssh_key" "keys" {
  for_each = local.ssh_keys

  name       = each.value.name
  public_key = each.value.public_key
}

resource "hcloud_server" "am_static_site" {
  name = var.server_name
  image = var.os_image
  server_type = var.server_type
  datacenter = var.datacenter
  user_data = <<EOT
#cloud-config
# Creates the user ansible for configuration with ansible playbooks
users:
- name: ansible
  groups: users, admin
  sudo: ALL=(ALL) NOPASSWD:ALL
  shell: /bin/bash
  ssh_authorized_keys:
    - ${var.ansible_user_ssh_key}

# Writes the ssh hardening config to a separate file for better management
write_files:
  - path: /etc/ssh/sshd_config.d/hardening.conf
    content: |
      PermitRootLogin no
      PasswordAuthentication no
      KbdInteractiveAuthentication no
      ChallengeResponseAuthentication no
      MaxAuthTries 2
      AllowTcpForwarding no
      X11Forwarding no
      AllowAgentForwarding no
      AuthorizedKeysFile .ssh/authorized_keys
      AllowUsers ${var.personal_user} ansible
runcmd:
  - curl -fsSL https://tailscale.com/install.sh | sh
  - tailscale up --auth-key=${var.tailscale_tailnet_key}
#   - >
#     curl -L \
#       -X POST \
#       -H "Accept: application/vnd.github+json" \
#       -H "Authorization: Bearer ${var.github_pa_token}" \
#       -H "X-GitHub-Api-Version: 2022-11-28" \
#       https://api.github.com/repos/${var.repo_name}/actions/workflows/${var.workflow_id}/dispatches \
#       -d '{"ref": "main"}'
EOT
  ssh_keys = [ for key in hcloud_ssh_key.keys : key.name  ]
  labels = {
    "role" : "webserver",
    "ssh_ip": var.tailscale_ip
  }
  public_net {
    ipv4 = var.primary_ip_id
  }
  firewall_ids = [var.firewall_id]
}