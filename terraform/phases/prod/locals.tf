locals {
  organization_name = "fraternitas"
  application_name  = "microservice"
  environment       = "prod"
  version           = "0.0.1"
  name              = "${local.organization_name}-${local.environment}-${local.application_name}"
}
