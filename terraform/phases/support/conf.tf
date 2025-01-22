terraform {
  backend "s3" {
    bucket         = "fraternitas-terraform-state-bucket"
    key            = "states/fraternitas-openid/terraform.tfstate"
    dynamodb_table = "fraternitas-terraform-lock-id"
    region         = "us-east-1"
    encrypt        = true
  }
}
