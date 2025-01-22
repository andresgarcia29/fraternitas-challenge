variable "function_name" {
  description = "Lambda name"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "nodejs12.x"
}

variable "handler" {
  description = "Lambda handler"
  type        = string
  default     = "index.handler"
}

variable "is_edge_lambda" {
  description = "value to determine if the lambda is an edge lambda"
  type        = bool
  default     = false
}

variable "s3" {
  type = object({
    enabled     = bool
    bucket_name = string
    key         = string
  })
  description = "values for the S3 bucket"
  default = {
    enabled     = false
    bucket_name = ""
    key         = ""
  }
}

variable "file" {
  type = object({
    enabled     = bool
    source_path = string
    output_path = string
  })
  description = "values for the file"
  default = {
    enabled     = false
    source_path = ""
    output_path = ""
  }
}

variable "environment" {
  description = "Environment"
  type        = map(string)
  default     = {}
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the S3 Bucket"

  validation {
    condition = can(
      lookup(var.tags, "env", null)
      ) && contains(
      ["dev", "qa", "staging", "prod"],
      lookup(var.tags, "env", "")
    )
    error_message = "The 'tag' map must contain an 'env' key with either ['dev', 'qa', 'staging', 'prod'] as its value."
  }
}

