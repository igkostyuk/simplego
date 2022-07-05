variable "app_name" { type = string }

variable "environment" { type = string }

variable "region" { description = "aws region" }

variable "vpc_id" { type = string }

variable "subnets" {
  type        = list(string)
  default     = null
  description = "The subnet IDs that include resources used by CodeBuild"
}

variable "repo_url" {
  description = "URL to Github repository to fetch source from"
}

variable "github_oauth_token" {
  description = "Github OAuth token with repo access permissions"
}

variable "branch_pattern" {}

variable "git_trigger_event" {}

variable "build_spec_file" {
  default = "buildspec.yml"
}
