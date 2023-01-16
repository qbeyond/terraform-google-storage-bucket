provider "google" {
  project = var.project_id
  user_project_override = true
  billing_project = var.project_id
}

data "google_project" "current" {
  project_id = var.project_id
}

# To use an existing encryption key, you have to grant permission to your Cloud Storage Agent
# The Key and the Bucket must be in the same location!
data "google_kms_crypto_key" "default" {
  name     = var.crypto_key_name
  key_ring = "projects/${var.project_id}/locations/${var.keyring_region}/keyRings/${var.keyring_name}"
}

resource "google_project_iam_member" "grant-google-storage-service-encrypt-decrypt" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:service-${data.google_project.current.number}@gs-project-accounts.iam.gserviceaccount.com"
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
  encryption_key = data.google_kms_crypto_key.default.id
}