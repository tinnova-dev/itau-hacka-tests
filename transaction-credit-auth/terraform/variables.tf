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
  default     = "transaction-credit-auth"
}

variable "container_port" {
  description = "Porta do container"
  type        = number
  default     = 8085
}

variable "cpu" {
  description = "CPU units para o container"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memória para o container em MB"
  type        = number
  default     = 512
}

variable "vpc_id" {
  description = "ID do VPC onde os recursos serão criados"
  type        = string
}

variable "private_subnets" {
  description = "Lista de IDs das subnets privadas"
  type        = list(string)
}

variable "risk_engine_service_url" {
  description = "URL do serviço risk-engine"
  type        = string
  default     = "http://risk-engine:8083"
} 