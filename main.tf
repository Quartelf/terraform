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

resource "google_compute_instance" "server_main" {
  count          = 1
  name           = "server-thomas"
  machine_type   = "n1-standard-1"
  zone           = "us-east1-b"
  tags           = ["allow-udp"]
  enable_display = true
  boot_disk {
    source = "projects/${var.project}/zones/${var.region}-b/disks/thomas-disco-servidor-ad"
    auto_delete = false
  }
  network_interface {
    subnetwork = google_compute_subnetwork.google_subnets[count.index].name
    access_config {

    }
  }
}

resource "google_compute_instance" "vm_instance" {
  count          = 1
  name           = "thomas-instance-${count.index}"
  machine_type   = "n1-standard-1"
  zone           = "southamerica-east1-b"
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