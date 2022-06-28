provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  cidr        = var.cidr
  az_count    = var.az_count
  app_name    = var.app_name
  environment = var.environment
}

module "alb" {
  source = "./modules/alb"

  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets

  environment = var.environment
  app_name    = var.app_name
  app_port    = var.app_port

  depends_on = [module.vpc]
}

module "ecs" {
  source = "./modules/ecs"

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets

  environment = var.environment
  app_image   = var.app_image
  app_name    = var.app_name
  app_port    = var.app_port
  app_count   = var.app_count

  alb_security_group_id = module.alb.alb_security_group_id
  alb_target_group_id   = module.alb.alb_target_group_id

  depends_on = [module.alb]
}
