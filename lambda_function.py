import json

def lambda_handler(event, context):
    print("Function invoked")
    print("Event received:", json.dumps(event))

    return {
        "statusCode": 200,
        "body": json.dumps({"message": "Hi there!"})
    }
