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
    count = 1
    name = "thomas-instance-${count.index}"
    machine_type = "n1-standard-1" 
    zone = "us-east1-b"
    tags = [ "allow-icmp" ]
    enable_display = true
    boot_disk {
      initialize_params {
        image = "windows-cloud/windows-2022"
      }
    }

    network_interface {
      network = "thomas-network" # funciona se tirar mas tudo bem
      subnetwork = google_compute_subnetwork.google_subnets[count.index].name
      access_config {
          
      }
    }
}

resource "google_compute_firewall" "rule-allow-icmp" {
  name    = "fw-thomas"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["allow-icmp"]
}
