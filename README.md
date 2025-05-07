# ShortURL AWS

A serverless URL shortener service built on AWS using API Gateway, Lambda, and DynamoDB.

## Stack:
- Python
- API Gateway
- Lambda
- DynamoDB

## Architecture

This URL shortener service uses AWS serverless technologies:

- **API Gateway**: HTTP API that handles incoming requests
- **Lambda**: Python function that processes requests and interacts with the database
- **DynamoDB**: NoSQL database that stores the mappings between short IDs and original URLs

## API Endpoints

### 1. Create Short URL

**Endpoint**: `POST /create`

**Request Body**:
```json
{
  "url": "https://example.com/very/long/url"
}
```

**Response**:
```json
{
  "shortUrl": "https://api-id.execute-api.region.amazonaws.com/abc123",
  "shortId": "abc123",
  "longUrl": "https://example.com/very/long/url"
}
```

### 2. Redirect to Original URL

**Endpoint**: `GET /{shortId}`

When a user accesses this endpoint with a valid short ID, they will be redirected (HTTP 301) to the original URL.

If the short ID is not found, a 404 error is returned.

## Implementation Details

### Lambda Function
- Handles both GET and POST requests
- For GET requests:
  - Extracts the shortId from the path
  - Queries DynamoDB for the corresponding longUrl
  - Returns a 301 redirect response with the longUrl in the Location header
- For POST requests:
  - Receives the longUrl in the request body
  - Generates a random shortId
  - Stores the shortId:longUrl mapping in DynamoDB
  - Returns the shortened URL along with the shortId and original longUrl

### DynamoDB
- Table structure:
  - `shortId` (string) as partition key
  - `longUrl` (string) as sort key

### IAM
- Lambda execution role has permissions to:
  - Read/write from DynamoDB table
  - Basic Lambda execution (for logging)

## Deployment

The infrastructure is defined using Terraform.

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Apply the configuration:
   ```
   terraform apply
   ```

3. After deployment, the API Gateway endpoint will be displayed in the outputs.

## Usage Example

1. Create a short URL:
   ```
   curl -X POST \
     https://your-api-endpoint/create \
     -H 'Content-Type: application/json' \
     -d '{"url": "https://example.com/very/long/url"}'
   ```

2. Use the returned short URL in a browser or with curl:
   ```
   curl -L https://your-api-endpoint/abc123
   ```