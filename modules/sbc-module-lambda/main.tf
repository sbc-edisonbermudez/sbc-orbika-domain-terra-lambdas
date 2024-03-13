variable "branch_name" {
  description = "The name of the Lambda function"
}

variable "function_name" {
  description = "The name of the Lambda function"
}

variable "tags" {
  description = "The tags of the Lambda function"
}

variable "timeout" {
  description = "The tags of the Lambda function"
  default     = 25
}

variable "subnet_a_id" {
  description = "Lambda subnet_a"
  default     = ""
}

variable "subnet_b_id" {
  description = "Lambda subnet_b"
  default     = ""
}

variable "security_group" {
  description = "Lambda security group"
  default     = ""
}

variable "id_account_aws" {
  description = "id account"
  default     = "*"
}

// Aprovisiona el rol que usará la lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

// Aprovisiona la lambda
resource "aws_lambda_function" "lambda" {
  function_name = "${var.function_name}-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
  filename      = "${path.module}/lambda_function.zip"
  timeout       = var.timeout

  vpc_config {
    subnet_ids         = [var.subnet_a_id, var.subnet_b_id]
    security_group_ids = [var.security_group]
  }
  tags = var.tags

  lifecycle {
    ignore_changes = [
      source_code_hash,
      environment,
      layers,
    ]
  }

}

resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = 90
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_policy" "function_log_group_policy" {
  name = "${var.function_name}-lambda-loggroup-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["logs:*"]
        Resource = [
          "${aws_cloudwatch_log_group.function_log_group.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "function_log_group_lambda" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.function_log_group_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_permissions_eni_interfaces" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_permissions_AWSStepFunctions" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
}

output "function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "function_lambda" {
  value = aws_lambda_function.lambda
}

output "function_role" {
  value = aws_iam_role.lambda_role
}

output "function_invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}
