variable "export_rules" {
  description = "contains all log analytics data export rules"
  type        = any
}

variable "resource_group" {
  description = "contains the resourcegroup name"
  type        = string
  default     = null
}
