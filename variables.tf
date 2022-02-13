variable "environment" {
  description = "Environment tag"
  default     = "Vault Benchmarking"
}

variable "prefix" {
  description = "used to associate resources with a person"
  default     = "dpeacock"
}

variable "region"{
  description = "The region Terraform deploys your instance"
}

variable "owner" {
  default     = "vaul"
  description = "person from HC that deployed the resource"
}

variable "hashi-region" {
  default     = "nymetro"
  description = "HC region that the owner belongs to"
}

variable "purpose" {
  default     = "testing"
  description = "what the resource is for"
}

variable "ttl" {
  default     = "12"
  description = "time to live before reaper should delete"
}

variable "root_volume_type" {
  default     = "gp2"
  description = "time to live before reaper should delete"
}

variable "local_cidr" {
  description = "CIDR to be used to enable remote access from your local machine to provisioned resources.  This is typically your Internet IP Address with /32 appended"
}