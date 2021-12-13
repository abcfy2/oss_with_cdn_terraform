variable "oss_bucket" {
  type        = string
  description = "OSS bucket for hosting website."
}

variable "cdn_domain" {
  type        = string
  description = "CDN domain for access website."
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
