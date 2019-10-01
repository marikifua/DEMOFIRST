provider "google" {
  credentials = "${file("/home/student/teraform_Jenkins_unlock/credential/marikkey.json")}"
  project = "quantum-tracker-251814"
  region  = "europe-west3"
  zone    = "europe-west3-c"
}

resource "google_compute_firewall" "port8080" {
  name    = "port8080"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["jenkins"]
}
resource "google_compute_firewall" "port8081" {
  name    = "port8081"
 network = "default"
  allow {
    protocol = "tcp"
    ports    = ["8081"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["carts"]
}
resource "google_compute_firewall" "port27017" {
  name    = "port27017"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }
  source_ranges = ["10.0.0.0/8"] 
  target_tags = ["mongodb"]
}
resource "google_compute_instance" "terraform-jenkins" {
  name         = "terraform-jenkins"
  machine_type = "n1-standard-1"
  tags = [ "jenkins" ]

  boot_disk {
    initialize_params {
      image = "centos-7-v20190916"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

metadata = { ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key ["${var.ssh_user}"])}" }
connection {
    type = "ssh"
    user = "${var.ssh_user}"
    host = "${google_compute_instance.terraform-jenkins.network_interface.0.access_config.0.nat_ip}"
    private_key="${file("${var.ssh_key}")}"
    agent = false   
  }
provisioner "file" {
      source      = "jenkins.sh"
      destination = "/tmp/jenkins.sh"
    }
    
  provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/jenkins.sh",
        "/tmp/jenkins.sh"
      ]
    }  
}

