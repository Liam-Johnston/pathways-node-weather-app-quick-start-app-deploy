module "service" {
  source = "./modules/fargate_service"

  username     = var.username
  project_name = var.project_name
  container_definitions = [
    {
      name  = var.project_name
      image = "${data.aws_ecr_repository.project_repository.repository_url}:1"
      cpu   = 0

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.log_group.name
          awslogs-region        = var.region
          awslogs-stream-prefix = var.project_name
        }
      }

      portMappings = [{
        protocol      = "tcp",
        containerPort = 3000
      }]
    }
  ]

  task_memory           = 512
  task_cpu              = 256
  desired_service_count = 1

  vpc_id     = data.aws_vpc.project_vpc.id
  subnet_ids = data.aws_subnet_ids.private.ids

  service_port     = 3000
  target_group_arn = aws_lb_target_group.ecs_target_group.arn
  alb_sg_id        = aws_security_group.alb_sg.id
  project_ecr_arn  = data.aws_ecr_repository.project_repository.arn

  loadbalancer_arn_suffix = aws_lb.load_balancer.arn_suffix
  target_group_arn_suffix = aws_lb_target_group.ecs_target_group.arn_suffix
}
