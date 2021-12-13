output "oss_extranet_endpoint" {
  value = "${alicloud_oss_bucket.bucket_website.id}.${alicloud_oss_bucket.bucket_website.extranet_endpoint}"
}

output "oss_intranet_endpoint" {
  value = "${alicloud_oss_bucket.bucket_website.id}.${alicloud_oss_bucket.bucket_website.intranet_endpoint}"
}

output "oss_intranet_location" {
  value = alicloud_oss_bucket.bucket_website.location
}

output "cdn_cname" {
  value = alicloud_cdn_domain_new.cdn.cname
}
