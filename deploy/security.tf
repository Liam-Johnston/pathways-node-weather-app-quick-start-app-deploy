resource "aws_security_group" "alb_sg" {
  name        = "${var.username}-${var.project_name}-alb-sg"
  description = "sg for the ${var.project_name} alb"
  vpc_id      = data.aws_vpc.project_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Internet Web Traffic"
  }
}
