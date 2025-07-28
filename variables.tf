variable "region" {
  default = "sa-east-1"
}

variable "key_name" {
  default = "projeto1"
}

variable "public_key_path" {
  description = "Caminho para a chave pública"
  default     = "projeto1.pub"
}

variable "ami_id" {
  default = "ami-0a174b8e659123575"
}

variable "instance_type" {
  default = "t2.micro"
}
