# Creates ssh key resources for any ssh keys in .ssh/
locals {
  ssh_files = fileset("${path.module}/.ssh/", "*.pub")
  ssh_keys = { for file in local.ssh_files : file => {
      name = replace(file, ".pub", "")
      public_key = file("${path.module}/.ssh/${file}")
    }
  }
}

resource "hcloud_ssh_key" "keys" {
  for_each = local.ssh_keys
  name       = each.value.name
  public_key = each.value.public_key
}

# Takes the cloud config and maps the values to variables
data "template_file" "cloud_config" {
  template = file("${path.module}/cloud-init/cloud-config.yaml")
  vars = {
    ansible_user_ssh_key = var.ansible_user_ssh_key
    personal_user = var.personal_user
    tailscale_tailnet_key = var.tailscale_tailnet_key
    hcloud_api_token = var.hcloud_api_token
    server_id = hcloud_server.am_static_site.id
    github_pa_token = var.github_pa_token
    repo_name = var.repo_name
    workflow_id = var.workflow_id
  }
}

resource "hcloud_server" "am_static_site" {
  name = var.server_name
  image = var.os_image
  server_type = var.server_type
  datacenter = var.datacenter
  user_data = data.template_file.cloud_config.rendered
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