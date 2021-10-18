data "aws_sns_topic" "rebuild_event_topic" {
  name = "${var.username}-${var.project_name}-rebuild-event"
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
  alarm_actions = [data.aws_sns_topic.rebuild_event_topic.arn]

  dimensions = {
    TargetGroup = var.target_group_arn_suffix
    LoadBalancer = var.loadbalancer_arn_suffix
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
