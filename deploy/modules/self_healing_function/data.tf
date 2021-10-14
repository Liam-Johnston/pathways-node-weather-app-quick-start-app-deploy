data "aws_iam_policy_document" "lambda_execution_policy" {
  statement {
    sid = "RetrieveSecretValue"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
        aws_secretsmanager_secret.github_access_token.arn
      ]
  }
}

data "aws_iam_policy_document" "lambda_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
