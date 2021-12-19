locals {
  domain_name = trimsuffix(var.domain_name, ".")
  cdn_alias   = trimprefix("${var.subdomain}.${local.domain_name}", ".")
}

resource "alicloud_oss_bucket" "bucket_website" {
  bucket = var.oss_bucket
  acl    = "public-read"

  website {
    index_document = var.index_document
    error_document = var.error_document
  }
}

resource "alicloud_cdn_domain_new" "cdn" {
  domain_name = local.cdn_alias
  cdn_type    = "web"
  scope       = var.cdn_scope

  sources {
    content = "${alicloud_oss_bucket.bucket_website.id}.${alicloud_oss_bucket.bucket_website.extranet_endpoint}"
    type    = "oss"
  }

  certificate_config {
    cert_type = "free"
  }
}

resource "alicloud_dns_record" "this" {
  count       = var.config_dns ? 1 : 0
  name        = local.domain_name
  host_record = coalesce(var.subdomain, "@")
  type        = "CNAME"
  value       = alicloud_cdn_domain_new.cdn.cname
}

# only if you use www prefix host
resource "alicloud_dns_record" "cname_for_trimprefix_www" {
  count       = var.config_dns && split(".", var.subdomain)[0] == "www" && var.auto_cname_without_www ? 1 : 0
  name        = local.domain_name
  host_record = coalesce(trimprefix(trimprefix(var.subdomain, "www"), "."), "@")
  type        = "CNAME"
  value       = alicloud_cdn_domain_new.cdn.cname
}

resource "alicloud_cdn_domain_config" "path_based_ttl_set" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "path_based_ttl_set"

  function_args {
    arg_name  = "path"
    arg_value = "/"
  }
  function_args {
    arg_name  = "ttl"
    arg_value = "604800" # 7d
  }
  function_args {
    arg_name  = "weight"
    arg_value = "99"
  }
}

resource "alicloud_cdn_domain_config" "origin_request_delete_accept_encoding" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "origin_request_header"

  function_args {
    arg_name  = "header_operation_type"
    arg_value = "delete"
  }
  function_args {
    arg_name  = "header_name"
    arg_value = "Accept-Encoding"
  }
}

resource "alicloud_cdn_domain_config" "origin_response_delete_vary" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "origin_response_header"

  function_args {
    arg_name  = "header_operation_type"
    arg_value = "delete"
  }
  function_args {
    arg_name  = "header_name"
    arg_value = "vary"
  }
}

resource "alicloud_cdn_domain_config" "ipv6" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "ipv6"

  function_args {
    arg_name  = "switch"
    arg_value = "on"
  }
}

resource "alicloud_cdn_domain_config" "gzip" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "gzip"

  function_args {
    arg_name  = "enable"
    arg_value = "on"
  }
}

resource "alicloud_cdn_domain_config" "brotli" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "brotli"

  function_args {
    arg_name  = "enable"
    arg_value = "on"
  }
  function_args {
    arg_name  = "brotli_level"
    arg_value = "11"
  }
}

resource "alicloud_cdn_domain_config" "tesla" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "tesla"

  function_args {
    arg_name  = "enable"
    arg_value = "on"
  }
  function_args {
    arg_name  = "trim_js"
    arg_value = "on"
  }
  function_args {
    arg_name  = "trim_css"
    arg_value = "on"
  }
}

resource "alicloud_cdn_domain_config" "https" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "https_option"

  function_args {
    arg_name  = "http2"
    arg_value = "on"
  }
  function_args {
    arg_name  = "ocsp_stapling"
    arg_value = "on"
  }
}

resource "alicloud_cdn_domain_config" "https_force" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "https_force"

  function_args {
    arg_name  = "enable"
    arg_value = "on"
  }
}

resource "alicloud_cdn_domain_config" "https_tls_version" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "https_tls_version"

  function_args {
    arg_name  = "tls10"
    arg_value = "off"
  }
  function_args {
    arg_name  = "tls13"
    arg_value = "on"
  }
}

resource "alicloud_cdn_domain_config" "HSTS" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "HSTS"

  function_args {
    arg_name  = "enabled"
    arg_value = "on"
  }
  function_args {
    arg_name  = "https_hsts_include_subdomains"
    arg_value = "off"
  }
  function_args {
    arg_name  = "https_hsts_max_age"
    arg_value = "5184000"
  }
}

resource "alicloud_cdn_domain_config" "range" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "range"

  function_args {
    arg_name  = "enable"
    arg_value = "on"
  }
}

resource "alicloud_cdn_domain_config" "video_seek" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "video_seek"

  function_args {
    arg_name  = "enable"
    arg_value = "on"
  }
  function_args {
    arg_name  = "flv_seek_by_time"
    arg_value = "on"
  }
}

resource "alicloud_cdn_domain_config" "ali_video_split" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "ali_video_split"

  function_args {
    arg_name  = "enable"
    arg_value = "on"
  }
}

resource "alicloud_cdn_domain_config" "image_transform" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "image_transform"

  function_args {
    arg_name  = "enable"
    arg_value = var.auto_webp ? "on" : "off"
  }
  function_args {
    arg_name  = "webp"
    arg_value = "on"
  }
  function_args {
    arg_name  = "filetype"
    arg_value = "jpg|jpeg|png|bmp|gif|tiff|jp2"
  }
  function_args {
    arg_name  = "orient"
    arg_value = "on"
  }
  function_args {
    arg_name  = "slim"
    arg_value = "90"
  }
}

resource "alicloud_cdn_domain_config" "set_hashkey_args" {
  domain_name   = alicloud_cdn_domain_new.cdn.domain_name
  function_name = "set_hashkey_args"

  function_args {
    arg_name  = "disable"
    arg_value = "on"
  }
  function_args {
    arg_name  = "keep_oss_args"
    arg_value = "off"
  }
  function_args {
    arg_name  = "hashkey_args"
    arg_value = join(",", var.keep_oss_args)
  }
}
