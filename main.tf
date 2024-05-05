data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}


# Get default values, for curiosity.
data "aws_vpc" "default" {
  default =true
}


resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  enable_dns_hostnames = "true"
  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2a"

  #Only the default VPC sets this
  map_public_ip_on_launch = "true"


  tags = {
    Name = "tf-example"
  }
}

resource "aws_security_group" "my" {
  name = "my_sg"
  description = "allow http"
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "http_in" {
  from_port  = "80"
  to_port    = "80"
  ip_protocol   = "tcp"
  cidr_ipv4  = "0.0.0.0/0"
  security_group_id =aws_security_group.my.id
}

resource "aws_vpc_security_group_egress_rule" "http_out" {
  from_port   = 0
  to_port     = 0
  ip_protocol    = "-1"
  cidr_ipv4   = "0.0.0.0/0"
  security_group_id = aws_security_group.my.id
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t3.nano"
  subnet_id     = aws_subnet.my_subnet.id

  vpc_security_group_ids = [aws_security_group.my.id]

  tags = {
    Name = "HelloWorld"
  }
}
