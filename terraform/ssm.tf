resource "aws_ssm_parameter" "lambda" {
  name = local.ssm_config_name
  type = "String"
  value = templatefile("${path.module}/templates/config_template.json", {
    server_host   = var.server_host
    server_port   = var.server_port
    user_name     = var.user_name
    other_timeout = var.other_timeout
    pow_timeout   = var.pow_timeout
    mail1         = var.mail1
    skype         = var.skype
    birthdate     = var.birthdate
    country       = var.country
    addrline1     = var.addrline1
    mailnum       = var.mailnum
    addrnum       = var.addrnum
  })
  description = "Configuration file for Lambda"
}
