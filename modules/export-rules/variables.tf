variable "export_rules" {
  description = "contains all log analytics data export rules"
  type        = any
}

variable "resourcegroup" {
  description = "contains the resourcegroup name"
  type        = string
  default     = null
}
