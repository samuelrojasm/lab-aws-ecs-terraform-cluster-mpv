terraform {
  # Versión de Terraform CLI que se permite usar
  required_version = "~> 1.0"

  # Providers y sus versiones
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}