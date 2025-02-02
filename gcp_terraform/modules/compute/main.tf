# Creates the google cloud compute instance for the webserver
resource "google_compute_instance" "gcp_webserver" {
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
      nat_ip = var.static_ip
    }
  }

  metadata = {
    ssh-keys = join("\n", [for key in local.ssh_keys : "${key.user}:${key.public_key}"])
  }

  metadata_startup_script = templatefile("${path.module}/startup_script/startup_script.sh",
  {
    ansible_user_ssh_key = var.ansible_user_ssh_key
    personal_user = var.personal_user
    tailscale_auth_key = var.tailscale_auth_key
    server_name = var.server_name
    github_pa_token = var.github_pa_token
    repo_name = var.repo_name
  })

  tags = ["webserver"]
  labels = {
    role = "webserver"
  }

  service_account {
    email = var.gsa_email
    scopes = ["cloud-platform"]
  }
}