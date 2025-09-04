# main.tf

# ----------------------------------------------------
# ECS Cluster
# ----------------------------------------------------
resource "aws_ecs_cluster" "main" {
  name = "mvp-ecs-cluster"
  tags = {
    Name = "mvp-ecs-cluster"
  }
}

# ----------------------------------------------------
# ECS Task Definition (El "plano" del contenedor)
# ----------------------------------------------------
# Define los recursos y configuraciones para el contenedor
resource "aws_ecs_task_definition" "main" {
  family                   = "mvp-fargate-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  # Roles de IAM
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  # Definición del contenedor en formato JSON
  container_definitions = jsonencode([
    {
      name      = "mvp-container"
      image     = var.container_image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/mvp-fargate-task"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# ----------------------------------------------------
# ECS Service (Gestiona las instancias de la tarea)
# ----------------------------------------------------
# Ejecuta y mantiene un número deseado de tareas de Fargate.
resource "aws_ecs_service" "main" {
  name            = "mvp-ecs-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 2 # Se recomienda 2 para alta disponibilidad
  launch_type     = "FARGATE"

  # Configuración de red
  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [module.ecs_tasks_sg.security_group_id]
  }

  # Configuración del Load Balancer
  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "mvp-container"
    container_port   = var.app_port
  }
}

# ----------------------------------------------------
# CloudWatch Log Group
# ----------------------------------------------------
# Necesario para almacenar los logs del contenedor.
resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/mvp-fargate-task"
}