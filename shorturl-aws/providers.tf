terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      verson = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
