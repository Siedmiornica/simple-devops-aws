provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "app" {
  name        = "simple-app-sg"
  description = "Security group for simple app"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "app" {
  key_name   = "simple-app-key"
  public_key = file("../simple-app-key.pub")
}

resource "aws_instance" "app" {
  ami             = "ami-0ae5de6628a0e374c"
  instance_type   = "t3.micro"
  key_name        = aws_key_pair.app.key_name
  security_groups = [aws_security_group.app.name]
  user_data       = file("../user_data.sh")

  tags = {
    Name = "simple-app"
  }
}

output "app_ip" {
  value = aws_instance.app.public_ip
}
