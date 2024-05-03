resource "aws_security_group" "master-class-sg" {
    name = "${var.tags_prefix}-sg"
    description = "Allow SSH and HTTP Traffic"
    vpc_id = var.vpc_id

    tags = {
      Name: "${var.tags_prefix}-sg"
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.master-class-sg.id
  cidr_ipv4         = var.default_route
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.master-class-sg.id
  cidr_ipv4         = var.default_route
  ip_protocol       = "-1" # semantically equivalent to all ports
}

data "aws_ami" "master-class-ami" {
    most_recent = true
    owners = [ "amazon" ]
    filter {
      name = "name"
      values = [ "al2023-ami-2023.3.*" ]
    }

    filter {
      name = "architecture"
      values = [ "x86_64" ]
    }
}

output "aws_ami_id" {
    value = data.aws_ami.master-class-ami.id
}

resource "aws_instance" "master-class-instance" {
    ami = data.aws_ami.master-class-ami.id
    instance_type = var.instance_type[0]

    subnet_id = var.subnet_id
    vpc_security_group_ids = [ aws_security_group.master-class-sg.id ]
    availability_zone = var.avail_zone[0]

    associate_public_ip_address = true
    key_name = "itoro_connect_remote"

    user_data = file("userData.sh")

    tags = {
      Name: "${var.tags_prefix}-instance"
    }
}
