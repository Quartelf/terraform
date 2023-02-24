terraform {
  required_version = ">= 1.1.0"
  backend "gcs" {
    bucket = "thomas-bucket-malwee"
    prefix = "/terraform-nas"
  }
}

provider "google" {
  project = "malwee-iac"
  region  = var.region
}



resource "google_compute_instance" "vm_instance" {
  count          = 2
  name           = "thomas-instance-${count.index}"
  machine_type   = "n1-standard-1"
  zone           = "us-east1-b"
  tags           = ["allow-udp"]
  enable_display = true
  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2022"
      type = "pd-standard"
      size = 50
    }
  }

  network_interface {
    network    = "thomas-network" # funciona se tirar mas tudo bem
    subnetwork = google_compute_subnetwork.google_subnets[count.index].name
    access_config {

    }
  }
}