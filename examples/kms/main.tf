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

data "google_kms_crypto_key" "default" {
  name     = var.crypto_key_name
  key_ring = "projects/${var.project_id}/locations/${var.keyring_region}/keyRings/${var.keyring_name}"
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

resource "google_project_iam_member" "grant-google-storage-service-encrypt-decrypt" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:service-${data.google_project.current.number}@gs-project-accounts.iam.gserviceaccount.com"
}


module "bucket" {
  source     = "../.."
  project_id = var.project_id
  name       = var.bucket_name
  iam = {
    "roles/storage.admin"  = ["group:${google_cloud_identity_group.basic.group_key.0.id}"]
  }
  encryption_key = data.google_kms_crypto_key.default.id
}