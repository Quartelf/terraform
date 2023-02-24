
resource "google_compute_network" "vpc_network" {
  project                 = "malwee-iac"
  name                    = "thomas-network"
  auto_create_subnetworks = false
  mtu                     = 1460
  routing_mode =  "REGIONAL"
}

resource "google_compute_subnetwork" "google_subnets" {
  count         = 2
  name          = "subnet-${count.index}-0"
  ip_cidr_range = "10.0.${count.index}.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "rule-allow-icmp" {
  name    = "fw-thomas-rules"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["3389", "53", "88", "135", "139", "389", "636", "445"]
  }
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "udp"
    ports    = ["53", "88", "123", "139", "389", "636"]
  }
  source_ranges = ["0.0.0.0/0"]
  source_tags   = ["allow-udp"]
}

