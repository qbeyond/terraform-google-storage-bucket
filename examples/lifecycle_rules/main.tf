provider "google" {
  project = var.project_id
  user_project_override = true
  billing_project = var.project_id
}

data "google_project" "current" {
  project_id = var.project_id
}

data "google_organization" "org" {
  count  = var.organization_domain != "" ? 1 : 0
  domain = var.organization_domain
}

resource "google_cloud_identity_group" "basic" {
  parent = "customers/${data.google_organization.org[0].directory_customer_id}"

  group_key {
      id = var.group_email
  }

  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }

  lifecycle {
    precondition {
      condition = can(regex(var.organization_domain, var.group_email))
      error_message = "group_email must be the same domain as organization"
    }
  }
}



module "bucket" {
  source     = "../.."
  project_id = var.project_id
  name       = var.bucket_name
  iam = {
    "roles/storage.admin"  = ["group:${google_cloud_identity_group.basic.group_key.0.id}"]
  }

  lifecycle_rules = try(var.lifecycle_rules, null)
}