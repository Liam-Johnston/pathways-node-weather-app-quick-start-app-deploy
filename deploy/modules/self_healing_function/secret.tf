resource "aws_secretsmanager_secret" "github_access_token" {
  name = "${var.username}/${var.project_name}/github-workflow-access-token"
}

resource "aws_secretsmanager_secret_version" "github_access_token" {
  secret_id = aws_secretsmanager_secret.github_access_token.id
  secret_string = var.github_access_token
}
