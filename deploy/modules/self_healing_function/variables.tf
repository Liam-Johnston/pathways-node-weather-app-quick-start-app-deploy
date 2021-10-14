variable "github_access_token" {
  description = "The access token to allow the service to invoke the redploy workflow"
  type = string
  sensitive = true
}

variable "username" {
  type        = string
  description = "Username of who is deploying this, for naming purposes"
}

variable "project_name" {
  type        = string
  description = "The name of the project that this service is apart of."
}

variable "target_group_arn_suffix" {
  type = string
  description = "The arn suffix of the target group that this service is deployed in"
}

variable "load_balancer_arn_suffix" {
  type = string
  description = "The arn suffix of the loadbalancer that this service is deployed behind"
}
