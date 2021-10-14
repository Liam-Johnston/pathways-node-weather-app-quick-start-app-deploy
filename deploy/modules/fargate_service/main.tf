resource "aws_ecs_cluster" "service_cluster" {
  name = "${var.username}-${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "service_task" {
  family = "${var.project_name}_family"
  container_definitions = jsonencode(var.container_definitions)

  memory = var.task_memory
  cpu = var.task_cpu

  requires_compatibilities = [
    "FARGATE"
  ]
  network_mode       = "awsvpc"
  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  lifecycle {
    ignore_changes = [ tags ]
  }
}

resource "aws_security_group" "service_sg" {
  name        = "${var.username}-${var.project_name}-ecs-sg"
  description = "sg for ${var.project_name} service"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.service_port
    to_port         = var.service_port
    protocol        = "TCP"
    security_groups = [var.alb_sg_id]
    description     = "ALB to ECS traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Service Access to Internet"
  }
}

resource "aws_ecs_service" "service" {
  name        = "${var.project_name}_service"

  cluster     = aws_ecs_cluster.service_cluster.id
  launch_type = "FARGATE"

  task_definition = aws_ecs_task_definition.service_task.arn
  desired_count   = var.desired_service_count

  network_configuration {
    subnets = var.subnet_ids
    security_groups = [
      aws_security_group.service_sg.id
    ]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_port   = var.service_port
    container_name   = var.project_name
  }
}
