resource "aws_instance" "tool" {
  instance_type = var.instance_type
  vpc_security_group_ids = []
  ami = var.ami

  tags = {
    Name = var.name
  }
}

variable "instance_type" {}
variable "ami" {}
variable "name" {}
variable "zone_id" {}

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