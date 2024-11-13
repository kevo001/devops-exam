terraform {
  backend "s3" {
    bucket = "pgr301-2024-terraform-state"
    key    = "54/terraform.tfstate"
    region = "eu-west-1"
  }
}