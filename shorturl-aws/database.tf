resource "aws_dynamodb_table" "url-dynamodb" {
  name         = "Urls"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "shortId"
  range_key    = "longUrl"

  attribute {
    name = "shortId"
    type = "S"
  }

  attribute {
    name = "longUrl"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-dynamodb"
    Environment = var.environment
  }
}
