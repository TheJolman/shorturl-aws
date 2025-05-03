variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "shorturl"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
