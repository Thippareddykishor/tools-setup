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

resource "vault_mount" "roboshop-dev" {

  path = "roboshop-dev"
  type = "kv"
  options = {version = "2"}
  description = "Robo shop secrets"

}

resource "vault_generic_secret" "cart" {
  path = "${vault_mount.roboshop-dev.path}/cart"
  data_json = jsonencode(
    {
      "REDIS_HOST"    :   "redis-dev.kommanuthala.store",
      "CATALOGUE_HOST":   "catalogue-dev.kommanuthala.store",
      "CATALOGUE_PORT":   "8080"
    }
  )
}

resource "vault_generic_secret" "catalogue" {
  path = "${vault_mount.roboshop-dev.path}/catalogue"
  data_json = jsonencode(
    {
      "MONGO" : "true",
      "MONGO_URL": "mongodb://mongodb-dev.kommanuthala.store:27017/catalogue"
    }
  )
}

resource "vault_generic_secret" "payment" {
  path = "${vault_mount.roboshop-dev.path}/payment"
  data_json = jsonencode(
    {
      "CART_HOST" : "cart-dev.kommanuthala.store",
      "CART_PORT": "8080",
      "USER_HOST": "user-dev.kommanuthala.store",
      "USER_PORT": "8080",
      "AMQP_HOST": "rabbitmq-dev.kommanuthala.store",
      "AMQP_USER": "roboshop",
      "AMQP_PASS": "roboshop123"
    }
  )
}

resource "vault_generic_secret" "shipping" {
  path = "${vault_mount.roboshop-dev.path}/shipping"
  data_json = jsonencode(
    {
      "CART_ENDPOINT": "cart-dev.kommanuthala.store",
      "DB_HOST" : "mysql-dev.kommanuthala.store"

    }
  )
}

resource "vault_generic_secret" "user" {
  path = "${vault_mount.roboshop-dev.path}/user"
  data_json = jsonencode(
    {
      "REDIS_URL" : "redis-dev.kommanuthala.store",
      "MONGO_URL" : "mongodb://mongodb-dev.kommanuthala.store:27017/users",
      "MONGO": "true"
    }
  )
}

resource "vault_generic_secret" "frontend" {
  path = "${vault_mount.roboshop-dev.path}/frontend"
  data_json = jsonencode(
    {
      "catalogue" : "http://catalogue-dev.kommanuthala.store:8080/",
      "user" : "http://user-dev.kommanuthala.store:8080/",
      "cart" : "http://cart-dev.kommanuthala.store:8080/",
      "shipping" : "http://shipping-dev.kommanuthala.store:8080/",
      "payment" : "http://payment-dev.kommanuthala.store:8080/"
    }
  )
}

 