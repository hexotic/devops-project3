data "aws_ami" "my-ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal*"]
  }
}

resource "aws_instance" "myec2" {
  ami             = data.aws_ami.my-ami.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = ["${var.sg_name}"]
  tags = {
    Name = "ec2_${var.env}_${var.user_name}"
  }

  # Prepare instance for ansible
  user_data = <<-EOF
      #!/bin/bash
      sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
      sudo systemctl restart ssh
      sudo sh -c 'echo -n ubuntu:${var.user_passwd} | chpasswd'
  EOF
}