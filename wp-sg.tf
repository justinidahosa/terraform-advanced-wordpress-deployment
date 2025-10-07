resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "allows ssh from bastion host and http from alb"
  vpc_id      = aws_vpc.wp_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "wordpress-sg" }
}

resource "aws_security_group_rule" "wp_allow_http_from_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.wordpress_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
  description              = "allows http from alb"
}

resource "aws_security_group_rule" "wp_allow_ssh_from_bastion_host" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.wordpress_sg.id
  source_security_group_id = aws_security_group.bastion_host_sg.id
  description              = "allows ssh from bastion host"
}

