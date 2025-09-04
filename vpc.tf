# ===============================================
# NETWORKING - VPC CON MÓDULO OFICIAL
# ===============================================

#-----------------------------------------------------------------------------------------
# VPC con los componentes necesarios para tu clúster de ECS Fargate:
#   subredes públicas y privadas, 
#   un Internet Gateway y 
#   un NAT Gateway, que son los componentes necesarios para tu clúster de ECS Fargate.
#-----------------------------------------------------------------------------------------

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
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 2) # Obtiene 2 zonas de disponibilidad (AZs)
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  # El módulo crea automáticamente:
  # - Internet Gateway
  # - NAT Gateways (uno por AZ por defecto)
  # - Route tables públicas y privadas
  # - Asociaciones de route tables

  # Habilitar NAT Gateway
  enable_nat_gateway = true
  enable_vpn_gateway = false

  # Opcional: usar un solo NAT Gateway para ahorrar costos
  single_nat_gateway = true # false:Un NAT Gateway por AZ para alta disponibilidad true:para un solo NAT Gateway

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

# ===============================================
# LO QUE NO DEBES HACER con el módulo oficial:
# ===============================================

# ❌ NO hagas esto - el módulo ya crea los route tables
# resource "aws_route_table" "private" {
#   count = length(var.availability_zones)
#   vpc_id = module.vpc.vpc_id
#   # ...
# }

# ❌ NO hagas esto - el módulo ya crea las asociaciones
# resource "aws_route_table_association" "private" {
#   count = length(var.availability_zones)
#   subnet_id = module.vpc.private_subnets[count.index]
#   # ...
# }

# ✅ SÍ puedes hacer esto - agregar rutas adicionales
# Si necesitas agregar rutas adicionales, lo haces DESPUÉS del módulo
# Ejemplo: agregar una ruta personalizada a las route tables privadas
# resource "aws_route" "private_custom_route" {
#   count = length(module.vpc.private_route_table_ids)
#   route_table_id         = module.vpc.private_route_table_ids[count.index]
#   destination_cidr_block = "192.168.0.0/16"
#   # Ejemplo: ruta a través de VPC Peering
#   vpc_peering_connection_id = aws_vpc_peering_connection.example.id
#  
#   depends_on = [module.vpc]
#}
# Ejemplo:
# resource "aws_route" "additional_route" {
#   route_table_id = module.vpc.private_route_table_ids[0]
#   destination_cidr_block = "172.16.0.0/12"
#   gateway_id = aws_vpn_gateway.example.id
# }
