terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }
}

locals {
  lambda_name = "lambda-${var.function_name}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }

  dynamic "statement" {
    for_each = var.is_edge_lambda ? [1] : []
    content {
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["edgelambda.amazonaws.com"]
      }

      actions = ["sts:AssumeRole"]
    }
  }
}

resource "aws_iam_role" "role" {
  name               = local.lambda_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  count = var.file.enabled && !var.s3.enabled ? 1 : 0

  type        = "zip"
  source_file = var.file.source_path
  output_path = var.file.output_path
}

resource "aws_lambda_function" "lambda" {
  function_name = local.lambda_name
  role          = aws_iam_role.role.arn
  handler       = var.handler
  runtime       = var.runtime

  s3_bucket        = var.s3.enabled ? var.s3.bucket_name : null
  s3_key           = var.s3.enabled ? var.s3.key : null
  source_code_hash = var.s3.enabled ? filebase64sha256(var.s3.key) : null

  filename = var.file.enabled && !var.s3.enabled ? var.file.output_path : null
  environment {
    variables = var.environment
  }
  tags = var.tags
}
