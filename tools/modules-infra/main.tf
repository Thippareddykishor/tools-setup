resource "aws_instance" "tool" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.tool.id]
  tags = {
    Name = var.name
  }
}



data "aws_route53_zone" "get_zone_id" {
  name = "kommanuthala.store"
}

resource "aws_route53_record" "tool_private" {
  zone_id = data.aws_route53_zone.get_zone_id.id
  name = "${var.name}-internal"
  ttl = 10
  type = "A"
  records = [aws_instance.tool.private_ip]
}

resource "aws_route53_record" "tool_public" {
  zone_id = data.aws_route53_zone.get_zone_id.id
  name = "${var.name}"
  ttl = 10
  records = [aws_instance.tool.public_ip]
  type = "A"
}

resource "aws_security_group" "tool" {
  name = "${var.name}-sg"
  description = "${var.name}-sg-desc"

  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
    ip_protocol = "-1"
    cidr_ipv4 = "0.0.0.0/0"
    security_group_id = aws_security_group.tool.id
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_ipv4 = "0.0.0.0/0"
  security_group_id = aws_security_group.tool.id
}

resource "aws_vpc_security_group_ingress_rule" "app_port" {
  ip_protocol = "tcp"
  from_port = var.port
  to_port = var.port
  cidr_ipv4 = "0.0.0.0/0"
  security_group_id = aws_security_group.tool.id
}
