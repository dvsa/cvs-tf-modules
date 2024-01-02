terraform {
  required_version = "~>1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.29.0"
    }
  }
}

resource "aws_lambda_function" "service" {
  function_name = "${var.service_name}-${terraform.workspace}"
  s3_bucket     = data.aws_s3_object.service.bucket
  s3_key        = data.aws_s3_object.service.key

  # This should be generated from the zip file as follows:
  # openssl dgst -sha256 -binary lambda.zip | openssl enc -base64
  source_code_hash = data.aws_s3_object.service.checksum_sha256

  handler                         = var.handler
  runtime                         = data.aws_lambda_function.template_lambda.runtime
  role                            = data.aws_lambda_function.template_lambda.role
  description                     = var.description
  memory_size                     = data.aws_lambda_function.template_lambda.memory_size
  timeout                         = data.aws_lambda_function.template_lambda.timeout
  reserved_concurrent_executions  = data.aws_lambda_function.template_lambda.reserved_concurrent_executions

  environment {
    variables = var.environment_variables != null && (var.environment_variables) > 0 ? var.environment_variables : null
  }

  dynamic "vpc_config" {
    for_each = data.aws_lambda_function.template_lambda.vpc_config
    content {
      security_group_ids = vpc_config.value["security_group_ids"]
      subnet_ids         = vpc_config.value["subnet_ids"]
    }
  }

  tracing_config {
    mode = "Active"
  }

  tags = {
    Component   = var.component
    Module      = "cvs-tf-service"
    Name        = "cvs-${terraform.workspace}-${var.component}/api"
    Environment = terraform.workspace
  }
}

resource "aws_lambda_alias" "main" {
  name             = terraform.workspace
  description      = "Alias for ${aws_lambda_function.service.function_name}"
  function_name    = aws_lambda_function.service.arn
  function_version = "$LATEST"
}

resource "aws_iam_role" "main" {
  name = var.csi

  assume_role_policy = data.aws_iam_policy_document.assumerole.json

  tags = merge(
    {
      "Name" = "${var.csi}/${var.service_name}",
    },
  )
}

resource "aws_iam_role_policy_attachment" "role-policy-attachment-default" {
  for_each   = toset(local.default_iam_policies)
  role       = aws_iam_role.main.name
  policy_arn = each.value
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${var.service_name}-${terraform.workspace}"
  retention_in_days = var.log_retention_days
  tags = {
    Component   = var.component
    Environment = terraform.workspace
    Project     = var.service_name
    Name        = "${var.service_name}-${terraform.workspace}"
  }
}
