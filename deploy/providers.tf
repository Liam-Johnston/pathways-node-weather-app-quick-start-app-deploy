provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Owner   = var.username
      Project = var.project_name
      App     = var.app_name
    }
  }
}
