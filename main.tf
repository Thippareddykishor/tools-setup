variable "tools" {
  default = {
    # vault= {
    #     instance_type = "t3.micro"
    #     port=8200
    # }
    jenkins={
      instance_type="t2.micro"
      port=8080
    }
    jenkins_agent={
      instance_type="t2.micro"
      port=80
    }
  }
}


module "tool_ec2" {
    source = "./module-infra"
    for_each = var.tools
    ami = var.ami
    instance_type = each.value["instance_type"]
    zone_id = "Z05764853PUNNX41R0FK9"
    name = each.key
    port = each.value["port"]
}

variable "ami" {
  default = "ami-09c813fb71547fc4f"
}

