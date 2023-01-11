variable "project_id" {
  type = string
  description = "The Project ID where to create the GCS Bucket"
}

variable "bucket_name" {
  type = string
  description = "The Bucket Name"
}

variable "organization_domain" {
  type = string
  description = "The domain of the organization"
}

variable "group_email" {
  type = string
  description = "The email for the group"
}

variable "retention_policy" {
  description = "map object for retention_policy"
  type = object({
    retention_period = number
    is_locked        = bool
  })
}

variable "logging_config" {
  description = "map object for logging config"
  type = object({
    log_bucket          = string
    log_object_prefix   = optional(string)
  })
}
