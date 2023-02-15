
resource "google_compute_network" "vpc_network" {
  project                 = "malwee-iac"
  name                    = "thomas-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "google_subnets" {
  count         = 4
  name          = "subnet-${count.index}.0"
  ip_cidr_range = "10.0.${count.index}.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

