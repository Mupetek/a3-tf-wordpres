variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_cidr_spri1" {
    type = string
    default = "10.0.1.0/24"
}

variable "vpc_cidr_spri2" {
    type = string
    default = "10.0.2.0/24"
}

variable "vpc_cidr_spri3" {
    type = string
    default = "10.0.3.0/24"
}

variable "vpc_cidr_spub1" {
    type = string
    default = "10.0.4.0/24"
}

variable "vpc_cidr_spub2" {
    type = string
    default = "10.0.5.0/24"
}

variable "vpc_cidr_spub3" {
    type = string
    default = "10.0.6.0/24"
}

variable "ami_id" {
    type = string
    default = "ami-0dc2d3e4c0f9ebd18"
}

variable "ec2_type" {
    type = string
    default = "t2.micro"
}

variable "ingress_ports_http" {
    type = string
    default = "80"
}

variable "ingress_ports_https" {
    type = string
    default = "443"
}

variable "ingress_ports_ssh" {
    type = string
    default = "22"
}

variable "ssh_key_pub" {
    type = string
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/chevFD1yfxioxmSr1FhQ1K5KAanNR54Un8QtX8x6lbyiHeew3IIENvR0qtJSpJI6GvwvFR89Z8zJLpAGahqz5n8nItZM/Ktixth4LsfIwCdz1sK64KCsjjxFvaeU8EjAr3UhEiLFhFQeI23jZ7ShwIFsutu+AKPvZRb95hKpCrXuxKWiCNJCZDnGxjkYFkW3Kv0Np1zgU8q0XYm1zMelt3puGDyhXte8rqnDMim6K+2bTsz2Ae3/b9uxvkdzx4yULDBNjEeO/EuscYbIjft4J8e/AojthDHLUq9D6vw1pYREgDOXLuYcsD+eMwUACrJs4hRPpH9a0eEtLLBB6YKtF603GVU/mUOv4M1zayA4sJvDiGT924O2Y97l67eyPa44iLV0b7nGESzLAYW1mjHgnyI70z8mMw/Q2TViHXywNCE5MNPNgs4IGeSOK8Gm46ny2mDd9CFBj9eoUNg9cvL7bAv1eqKu/gcTVlksIoK/ITPRXr6oMCIUa/E28Ah9fhERCne507lIU1M9afB+5tr8Q/N+qM/r6buldN4lBjj9MCckG0lSdI/VsC76szvngIBsTmP9WothoDGUageuzPIuMhIF47C21fOsBj7D1IO+JQ8T8cBT41UvYZnIhRltaS61zh89rLUzMD163krf1TnUaJAaT9yzelZLNxNqZuxTZw== mustafapetek65@gmail.com"
}