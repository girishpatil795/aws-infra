terraform {
  backend "s3" {
    bucket = "tfbucketss"
    key    = "backend/ToDo-App.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}