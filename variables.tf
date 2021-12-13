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

variable "domain" {
  type        = string
  description = "Your base domain. Full access domain will be {cdn_sub_dumain}.{domain}. E.g: example.com"
}

variable "cdn_sub_domain" {
  type        = string
  description = "CDN sub doman for access website. Full access domain will be {cdn_sub_dumain}.{domain}. E.g: www"
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
