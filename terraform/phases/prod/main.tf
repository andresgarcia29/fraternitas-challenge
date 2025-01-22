provider "aws" {
  region = "us-east-1"
}

module "s3" {
  source = "../../modules/aws_s3"

  name = local.name
  tags = {
    name = local.name
    env  = local.environment
  }
}

module "lambda" {
  source = "../../modules/aws_lambda"

  function_name = local.name
  handler       = "main.lambda_handler"
  runtime       = "python3.13"
  s3 = {
    enabled     = true
    bucket_name = module.s3.bucket_name
    key         = "${local.name}-${var.app_version}.zip"
  }
  environment = {
    SERVICE_NAME = "fraternitas"
  }

  tags = {
    name    = local.name
    service = local.name
    env     = local.environment
    version = local.version
  }
}
