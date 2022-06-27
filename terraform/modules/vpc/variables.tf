variable "cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}
variable "az_count" {
  description = "Number of AZs to cover in a given region"
  type        = number
  default     = 2
}

variable "app_name" { type = string }

variable "environment" { type = string }
