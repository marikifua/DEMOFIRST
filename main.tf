provider "google" {
  credentials = "${file("~/credential/marikkey.json")}"
  #credentials = "./credential/marikkey.json"
  project = "quantum-tracker-251814"
  region  = "europe-west3"
  zone    = "europe-west3-c"
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

resource "google_compute_instance" "carts" {
	name         = "carts"
	machine_type = "g1-small"


	boot_disk {
		initialize_params{
			size  = "10"
      type  = "pd-ssd"
      image = "centos-7-v20190905"
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
    host = "${google_compute_instance.carts.network_interface.0.access_config.0.nat_ip}"
   
    private_key="${file("${var.ssh_key}")}"
    agent = false   
  } 
 
  provisioner "file" {
      source      = "java.sh"
      destination = "/tmp/java.sh"
    }
  
  
  provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/java.sh",
        "/tmp/java.sh"
      ]
    }

    tags = [ "carts" ]
}
resource "google_compute_instance" "mongodb-tf" {
	name         = "mongodb-tf"
	machine_type = "g1-small"


	boot_disk {
		initialize_params{
			size  = "10"
      type  = "pd-ssd"
      image = "centos-7-v20190905"
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
    host = "${google_compute_instance.mongodb-tf.network_interface.0.access_config.0.nat_ip}"
    private_key="${file("${var.ssh_key}")}"
    agent = false   
  } 
 

  provisioner "file" {
      source      = "mongodb.sh"
      destination = "/tmp/mongodb.sh"
    }
  
  
  provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/mongodb.sh",
        "/tmp/mongodb.sh"
      ]
    }

    tags = [ "mongodb-tf" ]
}

