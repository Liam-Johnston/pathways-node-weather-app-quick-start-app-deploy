resource "aws_lb_target_group" "ecs_target_group" {
  name        = "${var.username}-${var.project_name}-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.project_vpc.id
}

resource "aws_lb" "load_balancer" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]

  subnets = data.aws_subnet_ids.public.ids

  enable_deletion_protection = false
}

resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}
