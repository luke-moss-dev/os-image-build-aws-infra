## Input variable declarations
## If no default, they are required when implementing module

variable "repository_name" {
  description = "Name of CodeCommit repository"
  type        = string
}

variable "environment" {
  description = "Type of environment for the repository. Ex. dev, prod, qa"
  type        = string
  default     = "dev"
}

variable "codebuild_name" {
  description = "The name of the CodeBuild project"
  type        = string
}

variable "codebuild_env_compute" {
  description = "The type of compute CodeBuild environment. Valid: BUILD_GENERAL1_SMALL, _MEDIUM, _LARGE, 2XLARGE"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_env_image" {
  description = "The docker image to be used as the CodeBuild environment"
  type        = string
  default     = "aws/codebuild/standard:4.0"
}

variable "codebuild_env_type" {
  description = "The type of CodeBuild environment. Valid: LINUX_CONTAINER, LINUX_GPU_CONTAINER, WINDOWS_CONTAINER, WINDOWS_SERVER_2019_CONTAINER, ARM_CONTAINER"
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "codebuild_env_image_credentials" {
  description = "The credentials for the image pull. Valid: CODEBUILD or SERVICE_ROLE -- if AWS Curated image, MUST use CODEBUILD"
  type        = string
  default     = "CODEBUILD"
}
