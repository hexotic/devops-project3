provider "aws" {
  region = "us-east-1"
}

module "ec2_prod" {
  source        = "../modules/ec2module"
  env           = "prod"
  instance_type = "t2.small"
  user_passwd   = "ubuntu"
}

resource "local_file" "prod_ec2_info" {
  filename = "ec2-info.txt"
  content  = "${module.ec2_prod.ec2_public_ip} ${module.ec2_prod.ec2_private_ip}"
}
