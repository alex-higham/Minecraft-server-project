variable "key_name" {
  description = "Name of the AWS key pair"
  type        = string
  default     = "Minecraft Key"
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

#variable "elastic_ip" {
#  description = "Existing Elastic IP address to associate with the instance"
#  type        = string
#  default     = "52.41.121.178"
#}
