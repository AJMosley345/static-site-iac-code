# Creates a static ip address for the cloud server
resource "google_compute_address" "static_ip" {
  project  = var.project_id
  name     = var.server_name
}

# Sets up a firewall for the server that only allows traffic from Tailscale (41641), Port 80 and Port 443 (for website traffic)
resource "google_compute_firewall" "static_site_firewall" {
  project  = var.project_id
  name     = var.server_name
  network  = "default"

  dynamic "allow" {
    for_each    = var.allowed_ports
    content {
      protocol  = allow.value.protocol
      ports     = allow.value.ports
    }
  }

  source_ranges = ["0.0.0.0/0"]
}

# Creates the Google Cloud compute instance for the webserver
resource "google_compute_instance" "gcp_webserver" {
  project      = var.project_id
  name         = var.server_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.os_image
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  metadata = {
    ssh-keys = join("\n", [for key in local.ssh_keys : "${key.name}:${key.public_key}"])
  }

  # metadata_startup_script = templatefile("${path.module}/startup_script/startup_script.sh",
  # {
  #   ansible_user_ssh_key = var.ansible_user_ssh_key
  #   personal_user = var.personal_user
  #   tailscale_auth_key = var.tailscale_auth_key
  #   server_name = var.server_name
  #   github_pa_token = var.github_pa_token
  #   repo_owner = var.repo_owner
  #   repo_name = var.repo_name
  # })

  tags = ["webserver"]
  labels = {
    role = "webserver"
  }
}