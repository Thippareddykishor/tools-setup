terraform {
  backend "s3" {
    bucket = "terraform-b87"
    key = "tools/state"
    region = "us-east-1"
  }
}