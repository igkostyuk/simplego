variable "vpc_id" { type = string }

variable "private_subnets" {}

variable "environment" { type = string }

variable "app_name" { type = string }

variable "app_port" { type = number }

variable "app_count" { type = number }

variable "image_repo" { type = string }

variable "image_tag" { type = string }


variable "alb_security_group_id" { type = string }

variable "alb_target_group_id" { type = string }


variable "fargate_cpu" {
  default = 512
}

variable "fargate_memory" {
  default = 1024
}
