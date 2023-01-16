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

module "bucket" {
  source     = "../.."
  project_id = var.project_id
  name       = random_string.bucket_name.result

  lifecycle_rules = {
    action = {
      type = "SetStorageClass" # or "Delete" or "AbortIncompleteMultipartUpload"
      storage_class = "MULTI_REGIONAL" # Must be set if type = "SetStorageClass", STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE, DURABLE_REDUCED_AVAILABILITY
    }
    condition = {
      age = 1
      created_before = "2023-01-01"
      custom_time_before = "2023-01-01"
      days_since_custom_time = 1
      days_since_noncurrent_time = 1
      matches_prefix = ["foo", "bar"]
      matches_storage_class = ["STANDARD", "MULTI_REGIONAL", "REGIONAL", "NEARLINE", "COLDLINE", "ARCHIVE", "DURABLE_REDUCED_AVAILABILITY"]
      matches_suffix = ["foo", "bar"]
      noncurrent_time_before = "2023-01-01"
      num_newer_versions = 1
      with_state = "LIVE" # or "ARCHIVED", "ANY"
    }
  }
}