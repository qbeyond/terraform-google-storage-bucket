provider "google" {}

resource "random_string" "bucketprefix" {
  length = 8
  special = false
  numeric = false
  upper = false
}

module "bucket" {
  source     = "../.."
  project_id = var.project_id
  prefix     = random_string.bucketprefix.result
  name       = var.bucket_name
}