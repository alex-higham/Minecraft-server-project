output "minecraft_server_ip" {
  description = "Elastic IP address of the Minecraft server"
  value       = data.aws_eip.minecraft.public_ip
}

output "minecraft_server_address" {
  description = "Address to connect to Minecraft server"
  value       = "${data.aws_eip.minecraft.public_ip}:25565"
}

output "ssh_connection" {
  description = "SSH command to connect to the server"
  value       = "ssh -i '${var.key_name}.pem' ubuntu@${data.aws_eip.minecraft.public_ip}"
}
