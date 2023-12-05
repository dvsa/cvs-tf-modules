output "lambda_arn" {
  description = "The unique ARN of the lambda"
  value = aws_lambda_function.service.qualified_invoke_arn
}

output "function_name" {
  description = "The name of the function"
  value = aws_lambda_function.service.function_name
}