resource "aws_instance" "wordpress" {
  ami           = "ami-0254b2d5c4c472488"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_subnet_1.id
  key_name      = "my-key"

  vpc_security_group_ids = [
    aws_security_group.wordpress_sg.id
  ]

  tags = {
    Name = "wordpress"
  }
  user_data = <<-EOF
              #!/bin/bash
              # Update the system and install required packages
              yum update -y
              amazon-linux-extras enable php8.0
              amazon-linux-extras install -y php8.0
              yum install -y httpd mysql wget php php-mysqlnd

              # Start and enable Apache
              systemctl start httpd
              systemctl enable httpd

              # Download and install WordPress
              cd /var/www/html
              wget https://wordpress.org/latest.tar.gz
              tar -xzf latest.tar.gz
              cp -r wordpress/* .
              rm -rf wordpress latest.tar.gz

              # Set permissions
              chown -R apache:apache /var/www/html
              chmod -R 755 /var/www/html

              # Configure WordPress to connect to RDS
              cp wp-config-sample.php wp-config.php
              sed -i "s/database_name_here/wordpressdb/" wp-config.php
              sed -i "s/username_here/admin/" wp-config.php
              sed -i "s/password_here/september2025/" wp-config.php
              sed -i "s/localhost/${aws_db_instance.wordpress_db.address}/" wp-config.php

              # Restart Apache
              systemctl restart httpd
              EOF
}


