resource "aws_s3_bucket_lifecycle_configuration" "bucket" {
  count = length(var.lifecycle_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.bucket.id
  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status
      filter {
        prefix = rule.value.prefix
      }
      dynamic "transition" {
        for_each = rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transition
        content {
          noncurrent_days = noncurrent_version_transition.value.noncurrent_days
          storage_class   = noncurrent_version_transition.value.storage_class
        }
      }
      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration
        content {
          noncurrent_days = noncurrent_version_expiration.value.noncurrent_days
        }
      }
      dynamic "abort_incomplete_multipart_upload" {
        for_each = rule.value.abort_incomplete_multipart_upload
        content {
          days_after_initiation = abort_incomplete_multipart_upload.value.days_after_initiation
        }
      }
      dynamic "expiration" {
        for_each = rule.value.expiration
        content {
          days                         = expiration.value.expired_object_delete_marker == true ? null : expiration.value.days
          expired_object_delete_marker = expiration.value.expired_object_delete_marker == true ? true : false
        }
      }
    }
  }
}
