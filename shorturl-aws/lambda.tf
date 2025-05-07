resource "archive_file" "lambda_zip" {
  type = "zip"
  source_file = "../lambda_function.py"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "url_lambda" {
  function_name = "ShortUrlLambda"
  role = aws_iam_role.lambda_exec_role.arn
  handler = "lambda_function.handler"
  runtime = "python3.13"

  filename = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  tags = {
    Name = "${var.project_name}-lambda"
    Environment = var.environment
  }
}
