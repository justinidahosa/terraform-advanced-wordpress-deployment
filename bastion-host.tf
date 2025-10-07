resource "aws_instance" "bastion_host" {
  ami           = "ami-0254b2d5c4c472488"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = "my-key"

  vpc_security_group_ids = [
    aws_security_group.bastion_host_sg.id
  ]

  tags = {
    Name = "bastion_host"
  }
}
