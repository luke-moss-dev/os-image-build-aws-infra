## Standard AWS DevOps Tool setup for OS Image Build Pipeline
## Author: Luke Mossburgh

# -------------------------------------------------------------------------------------------------
#  Secrets Manager                                                                                #
# -------------------------------------------------------------------------------------------------

resource "aws_secretsmanager_secret" "this" {
  name        = var.aws_secrets_manager_name
  description = "The set of secrets that are required by Packer in various phases of the build"

  #forces deletion immediately versus waiting period  consider keeping or not
  recovery_window_in_days = 0

  tags = {
    managed_by  = "Terraform"
    project     = "OS Image Build"
    environment = var.environment
  }

}

# -------------------------------------------------------------------------------------------------
#  Secrets Manager key/Values                                                                     #
# -------------------------------------------------------------------------------------------------

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = (file("${path.module}/secrets/secrets.json"))
}