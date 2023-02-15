terraform {
  required_version = ">= 1.1.0"
  backend "gcs" {
    bucket = "thomas-bucket-malwee"
    prefix = "/terraform-nas"
  }
}

provider "google" {
    project = "malwee-iac"
    region = var.region
}

resource "google_compute_instance" "vm_instance" {
    count = 4
    name = "thomas-instance" 
    machine_type = "n1-standard-1"
    zone = "us-east1-b"

    boot_disk {
      initialize_params {
        image = "debian-cloud/debian-11"
      }
    }

    network_interface {
      network = "thomas-network" # funciona se tirar mas tudo bem
      subnetwork = "subnet-${count.index}.0"
      access_config {
          
      }
    }
}