variable "key_name" {
  description = "Name of the AWS key pair"
  type        = string
  default     = "Minecraft Key"
}

variable "key_file" {
  description = "Local key file path"
  type        = string
  default     = "~/.ssh/Minecraft Key.pem"
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "Minecraft Security"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "Minecraft Terraform"
}

