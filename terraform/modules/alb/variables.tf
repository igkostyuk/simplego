variable "vpc_id" {
  type = string
}

variable "public_subnets" {}

variable "environment" {
  type    = string
  default = "dev"
}

variable "app_name" {
  type = string
}

variable "app_port" {
  type    = number
  default = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

