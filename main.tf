terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

data "aws_security_group" "minecraft" {
  name = var.security_group_name
}

data "aws_key_pair" "minecraft" {
  key_name = var.key_name
}

resource "aws_instance" "app_server" {
  ami                    = "ami-075686beab831bb7f"
  instance_type          = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.minecraft.id]
  key_name = data.aws_key_pair.minecraft.key_name

  tags = {
    Name = var.instance_name 
  }
}
