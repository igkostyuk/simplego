
terraform {
  backend "s3" {
    bucket         = "terraforms-states-dev"
    key            = "appgo/terraform.tfstate"
    encrypt        = true
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
  required_providers {
    aws = {
      version = "~> 4.20"
    }
  }
}
