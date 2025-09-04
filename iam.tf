# iam.tf

# ----------------------------------------------------
# Define las políticas de confianza para los roles
# ----------------------------------------------------
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ----------------------------------------------------
# ECS Task Execution Role
# ----------------------------------------------------
# Este rol permite que el agente de Fargate ejecute la tarea, acceda a imágenes y envíe logs.
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "mvp-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

# Adjunta la política gestionada de AWS para la ejecución de tareas de ECS.
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ----------------------------------------------------
# ECS Task Role (para tu aplicación)
# ----------------------------------------------------
# Este rol es para que la aplicación en el contenedor acceda a otros servicios de AWS.
# Por defecto, no tiene permisos, los puedes agregar aquí.
resource "aws_iam_role" "ecs_task_role" {
  name               = "mvp-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}