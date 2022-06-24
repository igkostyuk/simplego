variable "vpc_id" { type = string }

variable "private_subnets" {}

variable "environment" { type = string }


variable "app_image" { type = string }

variable "app_name" { type = string }

variable "app_port" { type = number }

variable "app_count" { type = number }


variable "alb_security_group_id" { type = string }

variable "alb_target_group_id" { type = string }


variable "fargate_cpu" {
  type    = string
  default = "512"
}

variable "fargate_memory" {
  type    = string
  default = "1024"
}

variable "image_tag" {
  type    = string
  default = "0.0.1"
}
