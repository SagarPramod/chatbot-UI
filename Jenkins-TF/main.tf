resource "aws_instance" "web" {
  ami                    = "ami-09b0a86a2c84101e1" #change ami id for different region
  instance_type          = "t2.large"
  key_name               = "ubuntu-node-kp" #change key name as per your setup
  vpc_security_group_ids = [aws_security_group.Jenkins-VM-SG.id]
  user_data              = file("installations.sh")

  tags = {
    Name = "Jenkins-Server"
  }

  root_block_device {
    volume_size = 40
  }
}

resource "aws_security_group" "Jenkins-VM-SG" {
  name        = "Jenkins-VM-SG"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-VM-SG"
  }
}