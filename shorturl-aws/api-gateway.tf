resource "aws_apigatewayv2_api" "url_shortener_api" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["content-type"]
  }

  tags = {
    Name        = "${var.project_name}-api"
    Environment = var.environment
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.url_shortener_api.id
  name        = "$default"
  auto_deploy = true

  tags = {
    Name        = "${var.project_name}-stage"
    Environment = var.environment
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.url_shortener_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.url_lambda.invoke_arn
}

# Route for creating new short URLs
resource "aws_apigatewayv2_route" "create_route" {
  api_id    = aws_apigatewayv2_api.url_shortener_api.id
  route_key = "POST /create"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Route for redirecting short URLs
resource "aws_apigatewayv2_route" "redirect_route" {
  api_id    = aws_apigatewayv2_api.url_shortener_api.id
  route_key = "GET /{shortId}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}