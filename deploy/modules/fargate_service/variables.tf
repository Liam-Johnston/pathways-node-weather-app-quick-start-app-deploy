variable "username" {
  type        = string
  description = "Username of who is deploying this, for naming purposes"
}

variable "project_name" {
  type        = string
  description = "The name of the project that this service is apart of."
}

variable "task_memory" {
  type = number
  description = "The amount of memory allocated for the service"
}

variable "task_cpu" {
  type = number
  description = "The amount of CPU allocated for the service"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the vpc that this service is being deployed in."
}

variable "subnet_ids" {
  type = list(string)
  description = "The IDs of the subnets that this service can be deployed into"
}

variable "service_port" {
  type = number
  description = "The port that this service operates on"
}

variable "alb_sg_id" {
  type = string
  description = "The security group id of the Application Load Balancer that directs traffic to this service"
}

variable "target_group_arn" {
  type = string
  description = "The ARN of the target group that this service is to be associated to"
}

variable "target_group_arn_suffix" {
  type = string
  description = "The ARN suffix of the target group that this service is to be associated to"
}

variable "loadbalancer_arn_suffix" {
  type = string
  description = "The ARN suffix of the target group that this service is to be associated to"
}

variable "desired_service_count" {
  type = number
  description = "The number of running services that you want."
}

variable "project_ecr_arn" {
  type = string
  description = "The ARN of the ecr that this project uses."
}

variable "container_definitions" {
  description = "Definition of the containers to deploy for this service."
  type        = list(object({
    name = string
    image = string
    cpu = number

    logConfiguration = object({
      logDriver = string
      options = object({
        awslogs-group = string
        awslogs-region = string
        awslogs-stream-prefix = string
      })
    })

    portMappings = list(object({
      protocol = string
      containerPort = number
    }))
  }))
}
