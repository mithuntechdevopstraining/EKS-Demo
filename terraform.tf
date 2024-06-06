terraform {
  required_version = "~>1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
  }
  backend "s3" {
    bucket = "mithuntech-terraform-state-backend-bucket"
    region = "ap-south-1"
    profile = "terraform"
    dynamodb_table = "terraform-state-locking"
  }
}