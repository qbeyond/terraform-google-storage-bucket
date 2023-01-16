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
  retention_policy = {
    retention_period = 1
    is_locked = true
  }

  logging_config = {
    log_bucket = random_string.bucket_name.result
    log_object_prefix = "foo"
  }
}