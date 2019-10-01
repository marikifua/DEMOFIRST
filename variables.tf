variable "name" {
    description = "Name of the resourcen."
    default     = "Demo1"
}
variable "network_ip" {
  description = "The private IP address to assign to the instance. If empty, the address will be automatically assigned."
  default     = ""
}  
variable "zone" {
  description = "The zone that the machine should be created in"
  default     = "europe-west3-c"    
} 

variable "image" {
    description = "The image from which to initialize this disk."
    default     = "centos-7"
}	
variable "ssh_user" {
    description = "User name"
    default     = "jenkins"
}
variable "ssh_pub_key" {
    type = "map"
    description = "Path to the public key for user marik"
    default = {
        "jenkins" = "~/.ssh/id_rsa.pub"
    }    
}
variable "ssh_key" {
    description = "Path to the private key for user marik"
    default     = "~/.ssh/id_rsa"
}
