terraform {
  backend "s3" {
    bucket = "projet03ajc-bucket"
    key    = "remote.tfstate"
    region = "us-east-1"
  }
}