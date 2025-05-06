# ShortURL AWS

## Stack:
- Go
- API Gateway
- Lambda
- DynamoDB

## Things to do:
### General
- Use Go to generate unique short IDs, need to handle collisions

### API Gateway
- Setup HTTP/REST API endpoint with API Gateway
    - POST for URL creation
    - GET for redirection

### Lambda Function
- GET:
    - Extract `shortId` from event and query DynamoDB for the corresponding `longUrl`
        - Return HTTP redirect response (301/302) w/ `longUrl `in the Location header
- POST:
    - Receive `longUrl` in request body, generate `shortId` with hash function, store `shortId:longUrl` mapping in DB
    - Return shortened URL

### DyanmoDB
- `shortId` (string) is the partition key w/ attribute for `longUrl` (string)

### IAM
- Lambda function's execution role should have necessary perms to read/write from DynamoDB table
    - `dynamodb:GetItem`
    - `dynamodb:PutItem`
