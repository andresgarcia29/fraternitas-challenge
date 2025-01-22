output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.lambda.function_name
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.lambda.arn
}

output "lamda_role_name" {
  description = "value of the role id"
  value       = aws_iam_role.role.name
}
