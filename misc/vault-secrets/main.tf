provider "vault" {
  address = "http://vault.kommanuthala.store:8200"
  token = var.vault_token
}

terraform {
  backend "s3" {
    bucket = "terraform-b87"
    key = "vault-secrets/state"
    region = "us-east-1"
  }
}

variable "vault_token" {}

resource "vault_mount" "ssh" {
  path = "infra"
  type = "kv"
  options = { version = "2" }
  description = "infra-secrets"
}

resource "vault_generic_secret" "ssh" {
  path = "${vault_mount.ssh.path}/ssh"
  data_json = jsonencode(
    {
        "username" : "ec2-user",
        "password" : "DevOps321"
    }
  )
}