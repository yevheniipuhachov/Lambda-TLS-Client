module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.0"

  function_name                     = local.lambda_name
  handler                           = var.handler
  runtime                           = var.runtime
  source_path                       = local.source_path
  artifacts_dir                     = local.artifacts_dir
  create_lambda_function_url        = var.create_lambda_function_url
  logging_log_group                 = local.log_group_name
  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days
  timeout                           = var.timeout
  memory_size                       = var.memory_size

  environment_variables = {
    SSM_PARAMETER_PATH   = "${aws_ssm_parameter.lambda.name}"
    TLS_CERT_SECRET_NAME = aws_secretsmanager_secret.cert.name
    TLS_KEY_SECRET_NAME  = aws_secretsmanager_secret.key.name
    REGION               = var.region
  }

  tags = {
    Environment = var.environment
    Team        = var.team
  }

  policies = [
    "AWSLambdaBasicExecutionRole",
  ]
  attach_policy_json = true
  policy_json = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:DescribeParameters",
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:GetParameter"
        ]
        Resource = "arn:aws:ssm:${var.region}:${local.account_id}:parameter${aws_ssm_parameter.lambda.name}"
      },
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ]
        Resource = ["arn:aws:secretsmanager:${var.region}:${local.account_id}:secret:${local.lambda_name}*"]
      }
    ]
  })
}
