variable "cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "1"
}
