resource "aws_vpc" "main" {
  cidr_block = var.cidr

  tags = { Name = "${var.app_name}-${var.environment}-VPC" }
}

module "codebuild" {

  source = "./modules/codebuild"

  vpc_id = aws_vpc.main.id

  environment = var.environment
  app_name    = var.app_name

  repo_url           = var.repo_url
  git_trigger_event  = var.git_trigger_event
  region             = var.region
  github_oauth_token = var.github_oauth_token
  branch_pattern     = var.branch_pattern

}
