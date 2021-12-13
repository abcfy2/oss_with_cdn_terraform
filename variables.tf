variable "oss_bucket" {
  type        = string
  description = "OSS bucket for hosting website."
}

variable "cdn_domain" {
  type        = string
  description = "CDN domain for access website."
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
