resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.username}-${var.project_name}"
}
