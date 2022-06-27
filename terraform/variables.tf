variable "region" {
  description = "region"
  type        = string
  default     = "us-east-1"
}

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
  type        = number
  default     = 2
}

variable "app_name" {
  type    = string
  default = "goapp"
}

variable "app_port" {
  type    = number
  default = 80
}

variable "app_count" {
  type    = number
  default = 2
}

variable "app_image" {
  type    = string
  default = "718206584555.dkr.ecr.us-east-1.amazonaws.com/goapp-dev:latest"
}
