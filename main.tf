locals {
  project_id       = "warm-rookery-325409"
  network          = "default"
  image            = "debian-cloud/debian-9"
  ssh_user         = "ansible-flask-app"
  private_key_path = "~/.ssh/ansbile_17bae99b3a0c"
}
provider "google" {
  project = local.project_id
  region  = "us-central1"
  zone    = "us-central1-c"
}
resource "google_service_account" "flask-app" {
  account_id = "flask-app-demo"
}
resource "google_compute_firewall" "flask" {
  name    = "flask-app-firewall"
  network = local.network

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_service_accounts = [google_service_account.flask-app.email]
}
resource "google_compute_instance" "default" {
  name         = "flask-vm"
  machine_type = "f1-micro"
  zone         = "us-central1-c"
  #tags         = ["ssh"]

  boot_disk {
    initialize_params {
        image = local.image
      
    }
  }
# Create a single Compute Engine instance
  network_interface {
    network = local.network
    access_config {}
  }
   service_account {
    email  = google_service_account.flask-app.email
    scopes = ["cloud-platform"]
  }
  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}, --private-key ${local.private_key_path} flask.yaml"
  }
}
resource "google_storage_bucket" "default" {
  name          = "bucket-myflask-17bae99b3a0c"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}
output "Web-server-URL" {
 value = join("",["http://",google_compute_instance.default.network_interface.0.access_config.0.nat_ip,":5000"])
}