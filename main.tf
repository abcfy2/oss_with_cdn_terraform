resource "alicloud_oss_bucket" "bucket-website" {
  bucket = var.oss_bucket
  acl    = "public-read"

  website {
    index_document = var.index_document
    error_document = var.error_document
  }
}
