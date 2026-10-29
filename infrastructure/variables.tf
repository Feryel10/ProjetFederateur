variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Configuration des environnements"

  type = map(object({
    project_name = string
    domain_name  = string
    record_name  = string
  }))
}