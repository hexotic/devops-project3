terraform {
  backend "s3" {
    bucket = "projet03ajc-bucket"
    key    = "prod.tfstate"
    region = "us-east-1"
  }
}
