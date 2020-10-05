## Standard AWS DevOps Tool setup for OS Image Build Pipeline
## Author: Luke Mossburgh

# -------------------------------------------------------------------------------------------------
#  Code Commit                                                                                    #
# -------------------------------------------------------------------------------------------------

# Code Commit Repo to hold packer scripts and hardening materials
resource "aws_codecommit_repository" "this" {
  repository_name = var.repository_name
  description     = "This is an initial repository for OS Image Build materials"
  default_branch  = "master"

  tags = {
    managed_by  = "Terraform"
    project     = "OS Image Build"
    environment = var.environment
  }
}

# -------------------------------------------------------------------------------------------------
#  IAM Configuration                                                                              #
# ------------------------------------------------------------------------------------------------#

##### TODO  Consider templating (template_file) these /policies to allow finer-grain access only 
#####    - Security considerations

# IAM Role for the builder will be read from data source containing applicable JSON
resource "aws_iam_role" "this" {
  name               = "${var.codebuild_name}-CodeBuildRole"
  assume_role_policy = file("${path.module}/policies/create-role.json")
}

# IAM custom policy to attach to the role just created
resource "aws_iam_role_policy" "this" {
  name   = "${var.codebuild_name}-CodeBuildPolicy"
  role   = aws_iam_role.this.name
  policy = file("${path.module}/policies/put-role-policy.json")
}

# Attaches the specific managed policy for reading secrets from Secret Manager (used in packer scripts)
#### TODO  Need data source or shove the arn directly into policy as a string???
data "aws_arn" "secrets_manager_read_write" {
  arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = data.aws_arn.secrets_manager_read_write.arn
}

# -------------------------------------------------------------------------------------------------
#  CodeBuild                                                                                     #
# -------------------------------------------------------------------------------------------------

# CodeBuild Project setup to run the OS Image Build
resource "aws_codebuild_project" "this" {
  name          = var.codebuild_name
  description   = "The codebuild project that will house and run the OS Image Build"
  service_role  = aws_iam_role.this.arn
  badge_enabled = true

  artifacts {
    type = "NO_ARTIFACTS"
  }

  #### TODO Could build own image to contain binaries used during the run
  environment {
    compute_type                = var.codebuild_env_compute
    image                       = var.codebuild_env_image
    type                        = var.codebuild_env_type
    image_pull_credentials_type = var.codebuild_env_image_credentials
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.codebuild_name}-log-group"
      stream_name = "${var.codebuild_name}-log-stream"
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.this.repository_name
    git_clone_depth = 1

  }

  source_version = "master"

  tags = {
    managed_by  = "Terraform"
    project     = "OS Image Build"
    environment = var.environment
  }
}