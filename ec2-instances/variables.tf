variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}

variable "environment_tag" {
  description = "Environment tag"
  default     = "vault-benchmark"
}

variable "prefix" {
  description = "used to associate resources with a person"
  default = "vault-benchmark"
}

variable "region"{
  description = "The region Terraform deploys your instance"
  default = "us-east-2"
}

variable "ami_id_value" {
  description = "Value to use for the ami_id"
  #default = "ami-00ffdc5f393f50c9b"
  default = "ami-038c3f1c53b990461"
}

variable "locust_master_instance_type" {
  description = "EC2 instance type for the Locust master server"
  default = "t2.medium"
}

variable "locust_worker_instance_type" {
  description = "EC2 instance type for the Locust master server"
  default = "t2.medium"
}

variable "owner" {
  default = "vault-benchmark"
  description = "person responsible for the deployed the resource"
}

variable "hashi-region" {
  default = "nymetro"
  description = "HC region that the owner belongs to"
}

variable "purpose" {
  default = "vault-benchmark"
  description = "what the resource is for"
} 

variable "ttl" {
  default = "12"
  description = "time to live before reaper should delete"
}

variable "local_cidr" {
  description = "CIDR to be used to enable remote access from your local machine to provisioned resources.  This is typically your Internet IP Address with /32 appended"
}