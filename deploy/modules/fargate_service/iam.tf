resource "aws_iam_policy" "ecs_ecr_access_policy" {
  name   = "${var.username}EcsEcrAccess"
  policy = data.aws_iam_policy_document.ecs_ecr_access_policy.json
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.username}EcsExecutionRole"

  assume_role_policy  = data.aws_iam_policy_document.ecs_execution_role.json
  managed_policy_arns = [aws_iam_policy.ecs_ecr_access_policy.arn]
}
