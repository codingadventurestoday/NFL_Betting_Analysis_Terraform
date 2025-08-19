//To Do: 1. figure out scheduling block to reduce money and start up vm instance after being shut down
// 2. write startup.sh to pull docker images and run the containers 
//3. figure out how to pull git repo into the correct docker images 

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
  project = var.GOOGLE_PROJECT
  region  = var.GOOGLE_REGION
  zone    = var.zone
}

#cloud infrastructure block/ customized settings of the resource 
resource "google_compute_instance" "vm_compute" {
  name         = "draftkings-vm"
  machine_type = "e2-micro"

  //Tags are used to apply network firewall rules to your VM

  //Labels are used for resource management, organization, and billing
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  metadata = {
    startup-script = file("startup.sh")
}

}

resource "google_compute_address" "static_ip" {
  name = "my-vm-static-ip"
}







# Provisioning Infrastructure Commands


# Deploying Commands 
# terraform init
# terrfaform refresh 
# terraform plan
# terraform apply 
# terraform show 

# codewithjeremy.com