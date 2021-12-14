variable "oss_bucket" {
  type        = string
  description = "OSS bucket for hosting website."
}

variable "index_document" {
  type        = string
  default     = "index.html"
  description = "Alicloud OSS returns this index document when requests are made to the root domain or any of the subfolders."
}

variable "error_document" {
  type        = string
  default     = null
  nullable    = true
  description = "(Optional) An absolute path to the document to return in case of a 4XX error."
}

variable "domain_name" {
  type        = string
  description = "Your domain name. Full access domain will be {subdomain}.{domain_name}. E.g: example.com"
}

variable "subdomain" {
  type        = string
  default     = ""
  description = "CDN subdoman for access website, if you want to use like `example.com` as access domain, keep this empty. Full access domain will be {cdn_sub_dumain}.{domain_name}. E.g: www"
}

variable "cdn_scope" {
  type        = string
  default     = "domestic"
  description = "(Optional) Scope of the accelerated domain. Valid values are 'domestic', 'overseas', 'global'"

  validation {
    condition     = contains(["domestic", "overseas", "global"], var.cdn_scope)
    error_message = "Allowed values for input_parameter are \"domestic\", \"overseas\", or \"global\"."
  }
}

variable "auto_webp" {
  type        = bool
  default     = true
  description = "Whether enable CDN auto webp convert."
}

variable "keep_oss_args" {
  type        = list(string)
  default     = []
  description = "(Optional) Keep origin oss args."
}

variable "config_dns" {
  type        = bool
  default     = true
  description = "Config DNS. If your DNS is not in Alicloud, please set this to false, then you should config CNAME by yourself in your DNS."
}
