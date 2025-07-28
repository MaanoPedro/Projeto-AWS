output "instance_url" {
  value		= "http://${aws_eip.web_eip.public_ip}"
  description	= "URL para acessar a instância EC2"
}

output "ssh_command" {
  value		= "ssh -i ${var.key_name}.pem ubuntu@${aws_eip.web_eip.public_ip}"
  description	= "Modo de acessar a máquina via SSH pelo terminal"
}
