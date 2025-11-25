resource "aws_security_group" "tool" {
  name = "${var.name}-sg"
  description = "${var.name} Security group"

  tags = {
    Name = "allow-tls"
  }
}

resource "aws_instance" "tool" {
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.tool.id]
  ami = var.ami

  tags = {
    Name = var.name
  }
}

resource "aws_route53_record" "private" {
  name = "${var.name}-internal"
  zone_id = var.zone_id
  ttl = 10
  type = "A"
  records = [aws_instance.tool.private_ip]
}

resource "aws_route53_record" "public" {
  name = "${var.name}"
  ttl = 10
  type = "A"
  zone_id = var.zone_id
  records = [aws_instance.tool.public_ip]
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.tool.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_app_port" {
  security_group_id = aws_security_group.tool.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.port
  to_port = var.port
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.tool.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}
