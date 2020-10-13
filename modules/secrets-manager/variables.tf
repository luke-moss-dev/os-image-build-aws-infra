variable "environment" {
  description = "Type of environment for the repository. Ex. dev, prod, qa"
  type        = string
  default     = "dev"
}

variable "aws_secrets_manager_name" {
  description = "The name of the secret in manager"
  default = "packer/golden-images/pipeline"
}