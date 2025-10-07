resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "allows mysql from wordpress server"
  vpc_id      = aws_vpc.wp_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "rds-sg" }
}

resource "aws_security_group_rule" "rds_allow_mysql_from_wp" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.wordpress_sg.id
  description              = "allow mysql from wordpress"
}
