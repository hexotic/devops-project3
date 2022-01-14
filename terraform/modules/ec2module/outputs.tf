output "ec2_public_ip" {
  value = aws_instance.myec2.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.myec2.private_ip
}