//To Do:
// 2. create chron jobs for daily data scrapping

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.49.0"
    }
  }
}

provider "google" {
  credentials = file(var.gcp_svc_key)
  project = var.gcp_project
  region  = var.region
  zone    = var.zone
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token = var.vault_token 
}

data "vault_generic_secret" "database_password" {
  path = "secret/myapp/database"
}

resource "google_compute_instance" "vm_compute" {
  name         = "draftkings-vm"
  machine_type = var.machine_type

  //Tags are used to apply network firewall rules to your VM
  tags = ["http-ssh-access"] //need to review this is correct

  //Labels are used for resource management, organization, and billing

  boot_disk {
    mode = "READ_WRITE"

    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      type = "pd-standard"
    }
  }

  scheduling {
    automatic_restart   = true
    provisioning_model  = "SPOT"
    on_host_maintenance = "MIGRATE"
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static_ip.address 
    }
  }

  attached_disk {
    source      = google_compute_disk.mysql_disk.id
    mode        = "READ_WRITE"
    device_name = "mysql-data-disk"
  }

  metadata = {
    startup-script = <<-EOT
    #!/bin/bash
    export MYSQL_ROOT_PASSWORD="${data.vault_generic_secret.database_secrets.data["mysql_password"]}"
  
    ./scripts/startup.sh
    EOT
  }
}

resource "google_compute_address" "static_ip" {
  name = "my-vm-static-ip"
}

resource "google_compute_disk" "mysql_disk" {
  name    = "mysql-data-disk"
  type    = "pd-standard"
  zone    = var.zone
  size    = 10
}

resource "google_compute_firewall" "allow-http-ssh" {
  name    = "allow-http-ssh-rule"
  network = "default"

  target_tags = ["http-ssh-access"]

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22", "80"] //replace port 80 with 443 for https access only
                            // only after SSL/TLS certificatie on web server running on the vm
  }
}

# codewithjeremy.com