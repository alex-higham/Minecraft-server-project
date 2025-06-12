terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.2"
    }
    time = {
      source = "hashicorp/time"
      version = "~> 0.9"
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

data "aws_eip" "minecraft" {
  tags = {
      Name = "Minecraft Terraform-eip"
    }
}

resource "aws_eip_association" "minecraft" {
  instance_id   = aws_instance.app_server.id
  allocation_id = data.aws_eip.minecraft.id
}

resource "time_sleep" "wait_for_instance" {
  depends_on = [aws_eip_association.minecraft]
  create_duration = "60s"
}

resource "null_resource" "minecraft_setup" {
  triggers = {
    instance_id = aws_instance.app_server.id
    eip_id      = data.aws_eip.minecraft.id
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${data.aws_eip.minecraft.public_ip},' --private-key='${pathexpand(var.key_file)}' --user=ubuntu --ssh-extra-args='-o StrictHostKeyChecking=no -o ConnectTimeout=30' minecraft-setup.yml"   
    
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
      ANSIBLE_TIMEOUT = "30"
    }
  }

  depends_on = [time_sleep.wait_for_instance]
}
