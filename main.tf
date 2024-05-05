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

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "tf-example"
  }
}

resource "security_group" "my" {
  name = "my_sg"
  description = "allow http"
  vpc_id = aws_vpc.my_vpc.id

}

resource "security_group_rule" "http_in" {
  type = "ingress"
  from_port= "80"
  to_port= "80"
  protocol = "tcp"
  cidr_blocks = "[0.0.0.0/0]"
  security_group_id =security_group.my.id

}


#resource "aws_instance" "web" {
#  ami           = data.aws_ami.app_ami.id
#  instance_type = "t3.nano"
#  subnet_id     = aws_subnet.my_subnet.id

#  tags = {
#    Name = "HelloWorld"
#  }
#}
