resource "aws_instance" "web" {
  ami                    = "ami-09b0a86a2c84101e1" 
  instance_type          = "t2.large"
  subnet_id              = aws_subnet.Jenkins-subnet.id
  key_name               = "ubuntu-node-kp" 
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
  vpc_id      = aws_vpc.Jenkins-vpc.id

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
#create a vpc
resource "aws_vpc" "Jenkins-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Jenkins-vpc"
  }
}
#Create Subnet 1 
resource "aws_subnet" "Jenkins-subnet" {
  vpc_id                  = aws_vpc.Jenkins-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Jenkins-subnet"
  }
}
#Create an Internet Gateway
resource "aws_internet_gateway" "Jenkins-igw" {
  vpc_id = aws_vpc.Jenkins-vpc.id

  tags = {
    Name = "Jenkins-igw"
  }
}
#Create a Route Table and associate with the Subnets
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.Jenkins-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Jenkins-igw.id
  }

  tags = {
    Name = "Jenkins-route-table"
  }
}
# Step 6: Associate Route Table with Subnet A
resource "aws_route_table_association" "assoc_a" {
  subnet_id      = aws_subnet.Jenkins-subnet.id
  route_table_id = aws_route_table.rt.id
}