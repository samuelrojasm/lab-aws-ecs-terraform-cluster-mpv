# ===============================================
# NETWORKING - VPC CON MÓDULO OFICIAL
# ===============================================

# Obtener información de las Availability Zones
# Algunas zonas de disponibilidad más nuevas requieren que explícitamente suscripción a ellas antes de poder usarlas.
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"] # Este filtro asegura que solo obtengas las zonas que están disponibles automáticamente para la cuenta.
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 2) # Obtiene 2 zonas de disponibilidad (AZs)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  # Habilitar NAT Gateway
  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = false # Un NAT Gateway por AZ para alta disponibilidad

  # DNS
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags
  tags = {
    Environment = var.environment
    Terraform   = "true"
  }

  #Tags específicos para subnets públicas
  public_subnet_tags = {
    Name = "${var.project_name}-public-subnet"
    Type = "Public"
  }

  # Tags específicos para subnets privadas
  private_subnet_tags = {
    Name = "${var.project_name}-private-subnet"
    Type = "Private"
  }

  # Tags para NAT Gateways
  nat_gateway_tags = {
    Name = "${var.project_name}-nat"
  }

  # Tags para Internet Gateway
  igw_tags = {
    Name = "${var.project_name}-igw"
  }

}




