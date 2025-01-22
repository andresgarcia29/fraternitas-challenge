def lambda_handler(event, context):
    """
    Entry point for the API Gateway.
    """

    return {"statusCode": 200, "message": "Hello, World!", "try": "5"}
