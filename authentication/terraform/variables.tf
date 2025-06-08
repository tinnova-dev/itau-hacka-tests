variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente de deploy (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Nome da aplicação"
  type        = string
  default     = "authentication"
}

variable "container_port" {
  description = "Porta do container"
  type        = number
  default     = 8080
}

variable "cpu" {
  description = "CPU units para o container"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Memória para o container em MB"
  type        = number
  default     = 1024
}

variable "vpc_id" {
  description = "ID do VPC onde os recursos serão criados"
  type        = string
}

variable "private_subnets" {
  description = "Lista de IDs das subnets privadas"
  type        = list(string)
}

variable "db_host" {
  description = "Host do banco de dados PostgreSQL"
  type        = string
}

variable "db_port" {
  description = "Porta do banco de dados PostgreSQL"
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "Nome do banco de dados PostgreSQL"
  type        = string
  default     = "authentication"
}

variable "db_username" {
  description = "Usuário do banco de dados PostgreSQL"
  type        = string
}

variable "db_password" {
  description = "Senha do banco de dados PostgreSQL"
  type        = string
  sensitive   = true
} 