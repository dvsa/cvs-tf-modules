terraform {
  required_version = "~>1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.29.0"
    }
  }
}

resource "aws_api_gateway_rest_api" "service_api" {
  name                = "${terraform.workspace}-${var.service_name}-api"
  binary_media_types  = ["application/octet-stream"]
  body                = templatefile(
    "${var.open_api_spec_file}",
    {
      lambda_auth_name        = "${local.base_lambda_auth_name}"
      authorizerUri           = "${local.base_lambda_auth_uri}"
      authorizerCredentials   = "${local.base_lambda_auth_credentials}"
      lambdas                 = tomap({
        for key, value in var.lambdas : key => module.lambdas[key].lambda_arn
      })
    }
  )
  policy              = data.aws_api_gateway_rest_api.primary_api_gateway.policy
  tags                = {
    Environment = terraform.workspace
    Service     = var.service_name
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.service_api.id
  triggers    = {
    workspace = terraform.workspace
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.service_api.body,
    ]))
  }
  depends_on          = [
    aws_api_gateway_rest_api.service_api
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "service_api_stage" {
  rest_api_id          = aws_api_gateway_rest_api.service_api.id
  deployment_id        = aws_api_gateway_deployment.deployment.id
  stage_name           = terraform.workspace
  xray_tracing_enabled = true

  tags = {
    Environment = terraform.workspace
  }
  depends_on = [
    aws_api_gateway_deployment.deployment
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_base_path_mapping" "api_gateway_mapping" {
  api_id      = aws_api_gateway_rest_api.service_api.id
  stage_name  = aws_api_gateway_stage.service_api_stage.stage_name
  domain_name = local.domain_name
  base_path   = "${var.service_name}-api"
}

module "lambdas" {
  for_each = var.lambdas
  source              = "../service-lambda"
  service_name        = "${each.value.service_name}"
  bucket_key          = "${each.value.bucket_key}"
  handler             = "${each.value.handler}"
  description         = "${each.value.description}"
  component           = "${var.component}"
  csi                 = "${var.csi}"
}

resource "aws_lambda_permission" "allow_invoke" {
  for_each = module.lambdas

  statement_id  = "AllowApiGatewayInvokeLambdaFunction"
  function_name = each.value.function_name
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.service_api.execution_arn}/*/*/*"
}