//To Do:
// 1. Walk through terraform finds
// 2. Walk through startup.sh file

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  credentials = file(var.gcp_svc_key)
  project = var.gcp_project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "vm_compute" {
  name         = "draftkings-vm"
  machine_type = var.machine_type

  //Tags are used to apply network firewall rules to your VM
  tags = ["http-ssh-access"]

  //Labels are used for resource management, organization, and billing
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
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
    startup-script = file("startup.sh")
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
    ports    = ["22", "80"]
  }
}



# Provisioning Infrastructure Commands


# Deploying Commands 
# terraform init
# terrfaform refresh 
# terraform plan
# terraform apply 
# terraform show 

# codewithjeremy.com