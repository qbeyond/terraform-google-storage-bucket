variable "project_id" {
  type = string
  description = "The Project ID where to create the GCS Bucket"
}

variable "keyring_name" {
  type = string
  description = "name of the keyring"
}

variable "crypto_key_name" {
  type = string
  description = "The name of your encryption key"
}

variable "keyring_region" {
  type = string
  description = "location of the keyring"
}

