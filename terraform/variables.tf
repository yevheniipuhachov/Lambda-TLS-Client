variable "addrline1" {
  description = "Address line 1"
  type        = string
}

variable "addrnum" {
  description = "Number of address lines"
  type        = number
}

variable "birthdate" {
  description = "User's birthdate"
  type        = string
}

variable "cloudwatch_logs_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group."
  type        = number
  default     = 14
}

variable "country" {
  description = "Country of the user"
  type        = string
}

variable "create_lambda_function_url" {
  description = "Controls whether the Lambda Function URL resource should be created"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment for the resources (e.g., dev, staging, production)."
  type        = string
  default     = "dev"
}

variable "handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_description" {
  description = "Description of the Lambda function."
  type        = string
  default     = "A Lambda function triggered via Lambda URL"
}

variable "lambda_handler" {
  description = "The function handler in the Lambda function."
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description = "The runtime environment for the Lambda function."
  type        = string
  default     = "python3.9"
}

variable "lambda_source_path" {
  description = "Path to the Lambda function source code."
  type        = string
  default     = "./src"
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs."
  type        = number
  default     = 14
}

variable "mail1" {
  description = "Primary email of the user"
  type        = string
}

variable "mailnum" {
  description = "Number of email addresses"
  type        = number
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments."
  type        = number
  default     = 128
}

variable "other_timeout" {
  description = "Timeout for other operations"
  type        = number
}

variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
  default     = "python3.9"
}

variable "server_host" {
  description = "Server host for the application"
  type        = string
}

variable "server_port" {
  description = "Server port for the application"
  type        = number
}

variable "skype" {
  description = "Skype handle of the user"
  type        = string
}

variable "team" {
  description = "Team responsible for the resources."
  type        = string
  default     = "devops"
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 600
}

variable "pow_timeout" {
  description = "Timeout for proof of work"
  type        = number
}

variable "user_name" {
  description = "Name of the user"
  type        = string
}
