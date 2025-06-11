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
  name = "Minecraft Security"
}

resource "aws_instance" "app_server" {
  ami                    = "ami-075686beab831bb7f"
  instance_type          = "t3.medium"
  vpc_security_group_ids = [data.aws_security_group.minecraft.id]

  tags = {
    Name = "Minecraft Terraform"
  }
}
