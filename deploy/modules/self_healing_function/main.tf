resource "aws_sns_topic" "rebuild_repo_event_topic" {
  name = "${var.username}-${var.project_name}-rebuild-repo-request"

    lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/self_healing_utility_function"
}

resource "aws_lambda_function" "this" {
  filename = "../dist/function.zip"
  function_name = "self_healing_utility_function"
  handler = "index.handler"
  role          = aws_iam_role.lambda_execution_role.arn


  source_code_hash = filebase64sha256("../dist/function.zip")
  runtime = "nodejs14.x"

  environment {
    variables = {
      GITHUB_USERNAME = "liam-johnston"
      GITHUB_TOKEN_SECRET_NAME = aws_secretsmanager_secret.github_access_token.name
    }
  }
}

resource "aws_sns_topic_subscription" "sns_lambda_sub" {
  topic_arn = aws_sns_topic.rebuild_repo_event_topic.arn
  protocol = "lambda"
  endpoint = aws_lambda_function.this.arn
}

resource "aws_cloudwatch_metric_alarm" "unhealthy_host_alarm" {
  alarm_name = "rebuild/unhealthy_host/pathways-node-weather-app-quick-start-app-deploy"

  comparison_operator = "LessThanThreshold"
  threshold = 0.9
  metric_name = "HealthyHostCount"
  namespace = "AWS/ApplicationELB"
  period = "60"
  statistic = "Average"
  evaluation_periods = "1"
  actions_enabled = "true"
  alarm_actions = [aws_sns_topic.rebuild_repo_event_topic.arn]

  dimensions = {
    TargetGroup = var.target_group_arn_suffix
    LoadBalancer = var.load_balancer_arn_suffix
  }

  lifecycle {
    ignore_changes = [
      datapoints_to_alarm,
      insufficient_data_actions,
      ok_actions,
      tags
    ]
  }
}
