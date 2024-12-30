resource "aws_secretsmanager_secret" "cert" {
  name                    = "${local.lambda_name}-cert"
  description             = "Certificate for Lambda function"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "cert" {
  secret_id     = aws_secretsmanager_secret.cert.id
  secret_string = "{}"

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret" "key" {
  name                    = "${local.lambda_name}-key"
  description             = "Private Key for Lambda function"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "key" {
  secret_id     = aws_secretsmanager_secret.key.id
  secret_string = "{}"

  lifecycle {
    ignore_changes = [secret_string]
  }
}
