data "aws_vpc" "project_vpc" {
  filter {
    name = "tag:Name"
    values = [
      "${var.username}-vpc"
    ]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.project_vpc.id

  tags = {
    Tier = "public"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.project_vpc.id

  tags = {
    Tier = "private"
  }
}

data "aws_ecr_repository" "project_repository" {
  name = "${var.username}-${var.project_name}"
}
