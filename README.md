# TLS Lambda Handler with Proof-of-Work (POW) and AWS Integration

This project implements an AWS Lambda function that establishes a secure TLS connection with a remote server, and communicates user-specific information based on server commands. Configuration and secrets are managed using AWS Systems Manager Parameter Store (SSM) and AWS Secrets Manager.

---

## Features
- **TLS Secure Communication**: Establishes secure TLS connections using certificates and keys stored in AWS Secrets Manager.
- **Proof-of-Work (POW)**: Computes a suffix to satisfy a given hash-based difficulty level.
- **AWS Integration**: Fetches configuration and secrets dynamically using AWS services.
- **Command Handling**: Responds to server commands with user-specific data stored in SSM Parameter Store.
- **Graceful Error Handling**: Includes comprehensive error messages for troubleshooting.

---

## Requirements
- **AWS Lambda Environment**
- **AWS Services**:
  - Secrets Manager for TLS certificates and keys.
  - Systems Manager Parameter Store for configuration.
- **Python 3.9 or later**
- **IAM Permissions**:
  - `ssm:GetParameter` for fetching configuration.
  - `secretsmanager:GetSecretValue` for fetching TLS credentials.

---

## Environment Variables
| Variable Name             | Description                             |
|---------------------------|-----------------------------------------|
| `SSM_PARAMETER_PATH`      | Path to the SSM parameter for config.   |
| `TLS_CERT_SECRET_NAME`    | Name of the Secrets Manager TLS cert.   |
| `TLS_KEY_SECRET_NAME`     | Name of the Secrets Manager TLS key.    |
| `REGION`                  | AWS region for API calls.               |

---

## Configuration Structure
The configuration should be stored in SSM Parameter Store as a JSON object. Below is an example:

```json
{
  "server": {
    "host": "example.com",
    "port": 443
  },
  "timeouts": {
    "pow_timeout": 3600
  },
  "user_info": {
    "name": "Ivan Drago",
    "mailnum": "1",
    "mail1": "ivan.drago@example.com",
    "skype": "ivan.drago.skype",
    "birthdate": "23.02.1950",
    "country": "Germany",
    "addrnum": "1",
    "addrline1": "Short street 3"
  }
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | terraform-aws-modules/lambda/aws | ~> 7.0 |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_ssm_parameter.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_caller_identity.account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addrline1"></a> [addrline1](#input\_addrline1) | Address line 1 | `string` | n/a | yes |
| <a name="input_addrnum"></a> [addrnum](#input\_addrnum) | Number of address lines | `number` | n/a | yes |
| <a name="input_birthdate"></a> [birthdate](#input\_birthdate) | User's birthdate | `string` | n/a | yes |
| <a name="input_country"></a> [country](#input\_country) | Country of the user | `string` | n/a | yes |
| <a name="input_mail1"></a> [mail1](#input\_mail1) | Primary email of the user | `string` | n/a | yes |
| <a name="input_mailnum"></a> [mailnum](#input\_mailnum) | Number of email addresses | `number` | n/a | yes |
| <a name="input_other_timeout"></a> [other\_timeout](#input\_other\_timeout) | Timeout for other operations | `number` | n/a | yes |
| <a name="input_pow_timeout"></a> [pow\_timeout](#input\_pow\_timeout) | Timeout for proof of work | `number` | n/a | yes |
| <a name="input_server_host"></a> [server\_host](#input\_server\_host) | Server host for the application | `string` | n/a | yes |
| <a name="input_server_port"></a> [server\_port](#input\_server\_port) | Server port for the application | `number` | n/a | yes |
| <a name="input_skype"></a> [skype](#input\_skype) | Skype handle of the user | `string` | n/a | yes |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | Name of the user | `string` | n/a | yes |
| <a name="input_cloudwatch_logs_retention_in_days"></a> [cloudwatch\_logs\_retention\_in\_days](#input\_cloudwatch\_logs\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. | `number` | `14` | no |
| <a name="input_create_lambda_function_url"></a> [create\_lambda\_function\_url](#input\_create\_lambda\_function\_url) | Controls whether the Lambda Function URL resource should be created | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment for the resources (e.g., dev, staging, production). | `string` | `"dev"` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda Function entrypoint in your code | `string` | `"lambda_function.lambda_handler"` | no |
| <a name="input_lambda_description"></a> [lambda\_description](#input\_lambda\_description) | Description of the Lambda function. | `string` | `"A Lambda function triggered via Lambda URL"` | no |
| <a name="input_lambda_handler"></a> [lambda\_handler](#input\_lambda\_handler) | The function handler in the Lambda function. | `string` | `"lambda_function.lambda_handler"` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | The runtime environment for the Lambda function. | `string` | `"python3.9"` | no |
| <a name="input_lambda_source_path"></a> [lambda\_source\_path](#input\_lambda\_source\_path) | Path to the Lambda function source code. | `string` | `"./src"` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Number of days to retain CloudWatch logs. | `number` | `14` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments. | `number` | `128` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy resources in. | `string` | `"us-east-1"` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda Function runtime | `string` | `"python3.9"` | no |
| <a name="input_team"></a> [team](#input\_team) | Team responsible for the resources. | `string` | `"devops"` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The amount of time your Lambda Function has to run in seconds. | `number` | `600` | no |
