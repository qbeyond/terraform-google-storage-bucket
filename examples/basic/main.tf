provider "google" {}

resource "random_string" "bucketprefix" {
  length = 8
  special = false
  numeric = false
  upper = false
}

module "bucket" {
  source     = "../.."
  project_id = "dev-gkedemo1-01"
  prefix     = random_string.bucketprefix.result
  name       = "qby-bucket"
  #iam = {
  #  "roles/storage.admin" = ["group:storage@example.com"]
  #}
}