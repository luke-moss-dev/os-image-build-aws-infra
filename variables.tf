variable "region" {
  description = "The region for resource deployment"
  type        = string
  default     = "us-east-1"
}

variable "repository_name" {
  description = "The name of the CodeCommit Repository"
  type        = string
}

variable "codebuild_name" {
  description = "The name of the CodeBuild Project"
  type        = string
}

variable "environment" {
  description = "Type of environment for the repository. Ex. dev, prod, qa"
  type        = string
  default     = "dev"
}