variable "region" {
  type        = string
  description = "aws region where EKS cluster is deployed"
  default       = "us-east-2"
}

variable "application_name" {
  type        = string
  description = "app name"
  default       = "vault"
}