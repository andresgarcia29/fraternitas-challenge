output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "bucket_region" {
  value = aws_s3_bucket.bucket.region
}

output "bucket_domain_name" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}
