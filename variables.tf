variable "aws_region" {
  type        = string
  description = "Región que usa el provider AWS"
  default     = "us-east-1"
}

# Variables de configuración
variable "project_name" {
  type        = string
  description = "Nombre del proyecto"
  default     = "mvp-ecs-fargate"
}

variable "environment" {
  type        = string
  description = "Ambiente (dev, prod, etc.)"
  default     = "lab"
}

variable "vpc_cidr" {
  description = "El bloque CIDR de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Una lista de CIDRs para las subredes públicas"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Una lista de CIDRs para las subredes privadas"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}