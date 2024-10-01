provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_security_group" "kubes_sg" {
  name        = "security-group"
  description = "Allow SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "kubes_1" {
  ami           = "ami-01811d4912b4ccb26"
  instance_type = "t2.micro"
  key_name      = "singapores"
  security_groups = [aws_security_group.kubes_sg.name]
  
  tags = {
    Name = "Server-1"
  }
}

resource "aws_instance" "kubes_2" {
  ami           = "ami-01811d4912b4ccb26"
  instance_type = "t2.micro"
  key_name      = "singapores"
  security_groups = [aws_security_group.kubes_sg.name]
  
  tags = {
    Name = "Server-2"
  }
}

output "kubes_1_public_ip" {
  value = aws_instance.kubes_1.public_ip
}

output "kubes_2_public_ip" {
  value = aws_instance.kubes_2.public_ip
}
