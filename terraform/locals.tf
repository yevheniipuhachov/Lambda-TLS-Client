locals {
  account_id      = data.aws_caller_identity.account.account_id
  lambda_name     = "${var.environment}-${var.team}-lambda"
  log_group_name  = "/lambda/${local.lambda_name}"
  source_path     = "${path.root}/../src"
  artifacts_dir   = "${path.root}/../builds/"
  ssm_config_name = "/${var.environment}/${var.team}/lambda/config"
}
