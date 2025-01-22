import json


def lambda_handler(event, context):
    """
    Entry point for the API Gateway.
    """

    return json.dumps({"statusCode": 200, "message": "Hello, World!", "try": "6"})
