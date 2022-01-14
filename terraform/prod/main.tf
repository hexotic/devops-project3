provider "aws" {
  region     = "us-east-1"
}

module "ec2_prod" {
  source        = "../modules/ec2module"
  env           = "prod"
  instance_type = "t2.micro"
}