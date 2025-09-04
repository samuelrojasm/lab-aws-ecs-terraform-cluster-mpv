# alb.tf

# ------------------------------
# Application Load Balancer (ALB)
# ------------------------------
resource "aws_lb" "main" {
  name               = "mvp-ecs-fargate-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.alb_security_group.security_group_id]
  subnets            = module.vpc.public_subnets

  tags = {
    Name = "mvp-ecs-fargate-alb"
  }
}

# ------------------------------
# Target Group
# ------------------------------
# Aquí es donde le dices al ALB en qué puerto debe comunicarse con tus tareas de Fargate.
resource "aws_lb_target_group" "main" {
  name        = "mvp-ecs-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    path = "/" # Puede cambiar esto por el endpoint de la aplicación si lo tienes
  }

  tags = {
    Name = "mvp-ecs-tg"
  }
}

# ------------------------------
# Listener
# ------------------------------
# Aquí se define que el tráfico que llega al ALB en el puerto 80 se redirija al Target Group.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}