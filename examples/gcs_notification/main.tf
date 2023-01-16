provider "google" {
  project = var.project_id
  user_project_override = true
  billing_project = var.project_id
}

resource "random_string" "bucket_name" {
  length           = 8
  special          = false
  upper            = false
}

resource "random_string" "topic" {
  length           = 8
  special          = false
  upper            = false
  numeric          = false
}

data "google_storage_project_service_account" "gcs_account" {
}

module "bucket" {
  source     = "../.."
  project_id = var.project_id
  name       = random_string.bucket_name.result
  notification_config = {
    enabled            = true
    payload_format     = "JSON_API_V1" # or None
    topic_name         = random_string.topic.result
    sa_email           = data.google_storage_project_service_account.gcs_account.email_address
    event_types        = ["OBJECT_FINALIZE", "OBJECT_METADATA_UPDATE", "OBJECT_DELETE", "OBJECT_ARCHIVE"]
    custom_attributes  = {
      example-attribute  = "example-attribute-value"
    }
  }
}