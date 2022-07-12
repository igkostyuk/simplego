resource "aws_ecr_repository" "ecr_app" {
  name = "${var.app_name}-${var.environment}"
}

resource "aws_ecr_repository" "ecr_alpine" {
  name = "alpine"
}

resource "aws_ecr_repository" "ecr_go" {
  name = "golang"
}

module "codebuild" {

  source = "./modules/codebuild"

  environment = var.environment
  app_name    = var.app_name

  repo_url           = var.repo_url
  git_trigger_event  = var.git_trigger_event
  region             = var.region
  github_oauth_token = var.github_oauth_token
  branch_pattern     = var.branch_pattern

}

resource "null_resource" "build" {
  provisioner "local-exec" {
    command     = "make push-init-images"
    working_dir = "../"
  }
  depends_on = [aws_ecr_repository.ecr_go, aws_ecr_repository.ecr_alpine, aws_ecr_repository.ecr_app]
}
