def lambda_handler(event, context):
    """
    Entry point for the API Gateway.
    """

    return {"statusCode": 200, "message": "Hello, World! + Test case 1", "try": "8"}
