# Security Group para ALB usando el módulo oficial
module "alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.project_name}-alb-sg"
  description = "Permitir el tráfico web entrante al Application Load Balancer"
  vpc_id      = module.vpc.vpc_id

  # Reglas de entrada para permitir tráfico HTTP y HTTPS desde cualquier lugar
  ingress_with_cidr_blocks = [
    {
      description = "HTTP desde internet"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "HTTPS desde internet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  # Reglas de egreso (permitir todo el tráfico saliente)
  egress_with_cidr_blocks = [
    {
      description = "All outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name        = "${var.project_name}-alb-sg"
    Environment = var.environment
  }
}
# Para referenciar el security group ID en otros recursos:
# module.alb_security_group.security_group_id


# Security Group para ECS Tasks de Fargate usando el módulo oficial
module "ecs_tasks_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.project_name}-ecs-tasks-sg"
  description = "Permitir el tráfico del ALB a las tareas de Fargate"
  vpc_id      = module.vpc.vpc_id

  # Regla de entrada para permitir el tráfico desde el Security Group del ALB
  ingress_with_source_security_group_id = [
    {
      description              = "App traffic from ALB"
      from_port                = var.app_port
      to_port                  = var.app_port
      protocol                 = "tcp"
      source_security_group_id = module.alb_security_group.security_group_id
    }
  ]

  # Regla de salida para permitir que la tarea se conecte a internet
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name        = "${var.project_name}-ecs-tasks-sg"
    Environment = var.environment
  }
}
# Para referenciar el security group ID en otros recursos:
# module.ecs_tasks_sg.security_group_id