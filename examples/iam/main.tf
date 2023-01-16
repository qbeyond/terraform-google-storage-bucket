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

resource "random_string" "group_email" {
  length           = 8
  special          = false
  upper            = false
}

data "google_organization" "default" {
  domain = var.organization_domain
}

# It is necessary to have permissions on your organizations level.
# You can add permissions to your account via https://admin.google.com
resource "google_cloud_identity_group" "basic" {
  parent = "customers/${data.google_organization.default.directory_customer_id}"

  group_key {
      id = "${random_string.group_email.result}@${data.google_organization.default.domain}"
  }

  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }
}

module "bucket" {
  source     = "../.."
  project_id = var.project_id
  name       = random_string.bucket_name.result
  iam = {
    "roles/storage.admin" = ["group:${google_cloud_identity_group.basic.group_key.0.id}"]
  }
}