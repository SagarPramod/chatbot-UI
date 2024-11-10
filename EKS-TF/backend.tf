terraform {
  backend "s3" {
    bucket         = "terraform-bucketv25"
    region         = "ap-south-1"
    key            = "Chatbot-UI/EKS-TF/terraform.tfstate"
    dynamodb_table = "Lock-Files"
    encrypt        = true
  }
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}
