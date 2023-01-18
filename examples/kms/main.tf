provider "google" {
  project = var.project_id
  user_project_override = true
  billing_project = var.project_id
}

data "google_project" "current" {
  project_id = var.project_id
}

resource "random_string" "keyring" {
  length           = 8
  special          = false
  upper            = false
  numeric          = false
}

resource "random_string" "key" {
  length           = 8
  special          = false
  upper            = false
  numeric          = false
}

# Warning!
# Creating this Resource creates a GCP KMS Keyring
# On Destruction, this resource will be deleted from the state
# but not from the project!

#It is required to have the same location as the bucket
resource "google_kms_key_ring" "default" {
  depends_on = [google_project_iam_member.grant-google-storage-service-encrypt-decrypt]
  name     = random_string.keyring.result
  location = var.keyring_location
}

resource "google_kms_crypto_key" "default" {
  name            = random_string.key.result
  key_ring        = google_kms_key_ring.default.id
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
  encryption_key = google_kms_crypto_key.default.id
}