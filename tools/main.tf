module "tool" {
 for_each = var.tools
  source = "./modules-infra"
  ami = var.ami
  instance_type = each.value.instance_type
  port = each.value.port
 name = each.key
}


variable "tools" {
  default = {
    vault= {
        instance_type="t3.micro"
        port=8200
    }
  }
}

variable "ami" {
  default = "ami-09c813fb71547fc4f"
}