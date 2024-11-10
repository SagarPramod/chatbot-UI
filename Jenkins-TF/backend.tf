terraform {
  backend "s3" {
    bucket         = "terraform-bucketv25"
    region         = "ap-south-1"
    key            = "Chatbot-UI/Jenkins-TF/terraform.tfstate"
  }
  required_version = ">=0.13.0"
}
