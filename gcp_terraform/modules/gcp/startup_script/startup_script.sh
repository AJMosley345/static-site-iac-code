#!/bin/bash

# Create ansible user
useradd -m -s /bin/bash -G users,admin ansible
echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
mkdir -p /home/ansible/.ssh
echo "${ansible_user_ssh_key}" >> /home/ansible/.ssh/authorized_keys
chown -R ansible:ansible /home/ansible/.ssh

# SSH Hardening
cat <<EOF > /etc/ssh/sshd_config.d/hardening.conf
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
MaxAuthTries 2
AllowTcpForwarding no
X11Forwarding no
AllowAgentForwarding no
AuthorizedKeysFile .ssh/authorized_keys
AllowUsers ${personal_user} ansible
EOF

# Install packages
apt-get update
apt-get install -y jq

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --auth-key=${tailscale_auth_key} --ssh --hostname=${server_name}

# Get Tailscale IP and Device ID
TAILSCALE_IP=$(tailscale ip -4)
TAILSCALE_DEVICE_ID=$(tailscale whois --json $${TAILSCALE_IP}:22 | jq -r .Node.StableID)
echo "Tailscale IP: $${TAILSCALE_IP}"
echo "Tailscale Device ID: $${TAILSCALE_DEVICE_ID}"

# Trigger GitHub Actions workflow
curl -L \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${github_pa_token}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/${repo_owner}/repos/${repo_name}/dispatches" \
    -d '{"event_type": "cloud_server_startup", "client_payload": {"server_name": "${server_name}"}}'