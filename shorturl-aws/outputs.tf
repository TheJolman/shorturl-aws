output "api_endpoint" {
  description = "The URL of the API Gateway"
  value       = aws_apigatewayv2_api.url_shortener_api.api_endpoint
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.url_lambda.function_name
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.url-dynamodb.name
}

output "create_url_endpoint" {
  description = "Endpoint for creating a short URL"
  value       = "${aws_apigatewayv2_api.url_shortener_api.api_endpoint}/create"
}

output "base_url" {
  description = "Base URL for short URLs"
  value       = aws_apigatewayv2_api.url_shortener_api.api_endpoint
}