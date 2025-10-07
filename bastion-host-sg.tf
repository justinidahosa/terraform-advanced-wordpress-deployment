resource "aws_security_group" "bastion_host_sg" {
  name        = "bastion-host-sg"
  description = "allow ssh from my ip address"
  vpc_id      = aws_vpc.wp_vpc.id

  ingress {
    description = "allows ssh from my ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["104.3.254.193/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "bastion-host-sg" }
}