resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-${var.environment}-cluster"
}

data "aws_iam_role" "task_role" { name = "ecsTaskExecutionRole" }

data "template_file" "app" {
  template = file("${path.module}/app.json.tpl")

  vars = {
    app_name       = var.app_name
    env            = var.environment
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    app_image      = var.app_image
    app_port       = var.app_port
    image_tag      = var.image_tag
  }
}

resource "aws_ecs_task_definition" "app" {
  family             = "${var.app_name}-${var.environment}-task"
  execution_role_arn = data.aws_iam_role.task_role.arn
  # task_role_arn            = var.ecs_task_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.app.rendered
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.app_name}-${var.environment}-tasks-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [var.alb_security_group_id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "main" {
  name            = "${var.app_name}-${var.environment}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.private_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_target_group_id
    container_name   = "${var.app_name}-${var.environment}-app"
    container_port   = var.app_port
  }
}
