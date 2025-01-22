provider "aws" {
  region = "us-west-1"
}

resource "aws_iam_role" "github_actions_aws" {
  name               = "github_oidc_role_ecr"
  assume_role_policy = data.aws_iam_policy_document.oidc.json
}

# ECR Role to push images
resource "aws_iam_policy" "deploy_ecr" {
  name        = "gha-deploy-ecr-policy"
  description = "Policy used for deployments on Github Action"
  policy      = data.aws_iam_policy_document.deploy_ecr.json
}

resource "aws_iam_role_policy_attachment" "attach_deploy_ecr" {
  role       = aws_iam_role.github_actions_aws.name
  policy_arn = aws_iam_policy.deploy_ecr.arn
}

# S3 Role to push files
resource "aws_iam_role" "github_actions_aws_read_write_s3" {
  name               = "github_oidc_role_read_write_s3"
  assume_role_policy = data.aws_iam_policy_document.oidc.json
}
resource "aws_iam_policy" "github_action_aws_read_write_s3" {
  name        = "gha-read-write-s3-policy"
  description = "Policy used for deployments on Github Action"
  policy      = data.aws_iam_policy_document.s3.json
}

resource "aws_iam_role_policy_attachment" "attach_read_write_s3_policy" {
  role       = aws_iam_role.github_actions_aws_read_write_s3.name
  policy_arn = aws_iam_policy.github_action_aws_read_write_s3.arn
}

# Terraform Role to push files
resource "aws_iam_role" "github_actions_aws_terraform" {
  name               = "github_oidc_role_terraform"
  assume_role_policy = data.aws_iam_policy_document.oidc.json
}
resource "aws_iam_policy" "github_action_aws_terraform" {
  name        = "gha-terraform-policy"
  description = "Policy used for deployments on Github Action"
  policy      = data.aws_iam_policy_document.terraform.json
}

resource "aws_iam_role_policy_attachment" "attach_terraform_policy" {
  role       = aws_iam_role.github_actions_aws_terraform.name
  policy_arn = aws_iam_policy.github_action_aws_terraform.arn
}
