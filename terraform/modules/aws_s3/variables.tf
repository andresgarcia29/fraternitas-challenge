variable "name" {
  type        = string
  description = "S3 Bucket name"
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    id     = string
    status = string
    prefix = string
    transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
    noncurrent_version_transition = optional(list(object({
      noncurrent_days = number
      storage_class   = string
    })), [])
    noncurrent_version_expiration = optional(list(object({
      noncurrent_days = number
    })), [])
    abort_incomplete_multipart_upload = optional(list(object({
      days_after_initiation = number
    })), [])
    expiration = optional(list(object({
      days                         = number
      expired_object_delete_marker = optional(bool)
    })), [])
  }))
  default = []
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
