resource "aws_iam_policy" "iam_for_lambda" {
  name   = "${var.username}LambdaExecutionPolicy"
  policy = data.aws_iam_policy_document.lambda_execution_policy.json
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.username}LambdaExecutionRole"

  assume_role_policy  = data.aws_iam_policy_document.lambda_execution_role.json
  managed_policy_arns = [aws_iam_policy.iam_for_lambda.arn]
}
