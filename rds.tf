resource "aws_db_subnet_group" "wordpress_db_subnet_group" {
  name       = "wordpress-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id,
    aws_subnet.private_subnet_3.id
  ]

  tags = {
    Name = "wordpress-db-subnet-group"
  }
}

resource "aws_db_instance" "wordpress_db" {
  identifier           = "wordpress-db"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username             = "admin"
  password             = "september2025"
  db_name = "wordpressdb"
  db_subnet_group_name = aws_db_subnet_group.wordpress_db_subnet_group.id

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  skip_final_snapshot = true
}

