import json
import os
import random
import string
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])


def generate_short_id(length=6):
    """Generate a random short ID"""
    chars = string.ascii_letters + string.digits
    return "".join(random.choice(chars) for _ in range(length))


def create_short_url(long_url):
    """Create a short URL entry in DynamoDB"""
    short_id = generate_short_id()

    # Check if ID already exists
    response = table.get_item(Key={"shortId": short_id, "longUrl": long_url})
    while "Item" in response:
        short_id = generate_short_id()
        response = table.get_item(Key={"shortId": short_id, "longUrl": long_url})

    table.put_item(Item={"shortId": short_id, "longUrl": long_url})

    return short_id


def get_long_url(short_id):
    """Retrieve the long URL for a given short ID"""
    response = table.query(
        KeyConditionExpression=boto3.dynamodb.conditions.Key("shortId").eq(short_id)
    )

    if response["Items"]:
        return response["Items"][0]["longUrl"]
    else:
        return None


def lambda_handler(event, context):
    """Main Lambda handler function"""
    print("Event received:", json.dumps(event))

    route_key = event.get("routeKey", "")
    path = event.get("rawPath", "")

    if route_key == "POST /create":
        try:
            body = json.loads(event.get("body", "{}"))
            long_url = body.get("url")

            if not long_url:
                return {
                    "statusCode": 400,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"error": "URL is required"}),
                }

            short_id = create_short_url(long_url)

            domain = event.get("requestContext", {}).get("domainName", "")
            stage = event.get("requestContext", {}).get("stage", "")
            base_url = (
                f"https://{domain}/{stage}"
                if stage != "$default"
                else f"https://{domain}"
            )

            return {
                "statusCode": 201,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps(
                    {
                        "shortUrl": f"{base_url}/{short_id}",
                        "shortId": short_id,
                        "longUrl": long_url,
                    }
                ),
            }
        except Exception as e:
            print(f"Error creating short URL: {str(e)}")
            return {
                "statusCode": 500,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": f"Internal server error: {str(e)}"}),
            }

    # GET /{shortId} endpoint
    elif route_key.startswith("GET /"):
        try:
            print("Full path: ", path)
            short_id = path.split("/")[-1]

            if not short_id:
                return {
                    "statusCode": 400,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"error": "Short ID is required"}),
                }

            long_url = get_long_url(short_id)

            if long_url:
                # Return redirect to the long URL
                return {
                    "statusCode": 301,
                    "headers": {"Location": long_url, "Content-Type": "text/plain"},
                    "body": f"Redirecting to {long_url}",
                }
            else:
                return {
                    "statusCode": 404,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"error": "Short URL not found"}),
                }
        except Exception as e:
            print(f"Error redirecting: {str(e)}")
            return {
                "statusCode": 500,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": f"Internal server error: {str(e)}"}),
            }

    else:
        return {
            "statusCode": 404,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "Route not found"}),
        }
