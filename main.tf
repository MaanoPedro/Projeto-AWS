provider "aws" {
  region = var.region
}

resource "aws_key_pair" "projeto1_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC_Projeto1"
  }
}

resource "aws_subnet" "public1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Publica-1a"
  }
}

resource "aws_subnet" "public2b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Publica-2b"
  }
}

resource "aws_subnet" "private1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "Privada-1a"
  }
}

resource "aws_subnet" "private2b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = "Privada-2b"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.public1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.public2b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web_sg" {
  name        = "WebSG"
  description = "Permite HTTP e SSH"
  vpc_id      = aws_vpc.main.id
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

resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.public1a.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  user_data = file("${path.module}/user_data.sh")
  
  tags = {
    Name        = "Projeto"
    CostCenter  = "XXXXXX"
    Project     = "Projeto"
  }

  volume_tags = {
    Name        = "Projeto"
    CostCenter  = "XXXXXX"
    Project     = "Projeto"
  }

  associate_public_ip_address = true
}

resource "aws_eip" "web_eip" {
  instance = aws_instance.ec2.id
  tags = {
    Name        = "ElasticIP"
  }
}
