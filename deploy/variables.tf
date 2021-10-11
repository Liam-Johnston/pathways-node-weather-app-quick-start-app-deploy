variable "region" {
  type        = string
  description = "The region to deploy in"
  default     = "us-east-1"
}

variable "username" {
  type        = string
  description = "Username of who is deploying this, for naming purposes"
  default     = "liamjohnston"
}

variable "app_name" {
  type        = string
  description = "The name of this application"
  default     = "app"
}

variable "project_name" {
  type        = string
  description = "The name of the project that this app is apart of."
  default     = "node-weather-app"
}
