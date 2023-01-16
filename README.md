# Google Cloud Storage Module
Original Module from [Cloud-Foundation-Fabric](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric)

To use an existing encryption key, you have to grant permission to your Cloud Storage Agent \
which is automated by Terraform. \

The Key and the Bucket must be in the same location! \
<!-- BEGIN_TF_DOCS -->
## Usage

This Module creates a GCP Storage Bucket
```hcl
provider "google" {
  project = var.project_id
  user_project_override = true
  billing_project = var.project_id
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
}

module "bucket" {
  source     = "../.."
  project_id = var.project_id
  name       = var.bucket_name
  iam = {
    "roles/storage.admin" = ["group:${google_cloud_identity_group.basic.group_key.0.id}"]
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.1 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.40.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.40.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Bucket name suffix. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Bucket project id. | `string` | n/a | yes |
| <a name="input_cors"></a> [cors](#input\_cors) | CORS configuration for the bucket. Defaults to null. | <pre>object({<br>    origin          = list(string)<br>    method          = list(string)<br>    response_header = list(string)<br>    max_age_seconds = number<br>  })</pre> | `null` | no |
| <a name="input_encryption_key"></a> [encryption\_key](#input\_encryption\_key) | KMS key that will be used for encryption. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Optional map to set force destroy keyed by name, defaults to false. | `bool` | `false` | no |
| <a name="input_iam"></a> [iam](#input\_iam) | IAM bindings in {ROLE => [MEMBERS]} format. | `map(list(string))` | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to be attached to all buckets. | `map(string)` | `{}` | no |
| <a name="input_lifecycle_rule"></a> [lifecycle\_rule](#input\_lifecycle\_rule) | Bucket lifecycle rule. | <pre>object({<br>    action = object({<br>      type          = string<br>      storage_class = string<br>    })<br>    condition = object({<br>      age                        = number<br>      created_before             = string<br>      with_state                 = string<br>      matches_storage_class      = list(string)<br>      num_newer_versions         = string<br>      custom_time_before         = string<br>      days_since_custom_time     = string<br>      days_since_noncurrent_time = string<br>      noncurrent_time_before     = string<br>    })<br>  })</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Bucket location. | `string` | `"EU"` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | Bucket logging configuration. | <pre>object({<br>    log_bucket        = string<br>    log_object_prefix = string<br>  })</pre> | `null` | no |
| <a name="input_notification_config"></a> [notification\_config](#input\_notification\_config) | GCS Notification configuration. | <pre>object({<br>    enabled           = bool<br>    payload_format    = string<br>    topic_name        = string<br>    sa_email          = string<br>    event_types       = list(string)<br>    custom_attributes = map(string)<br>  })</pre> | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Optional prefix used to generate the bucket name. | `string` | `null` | no |
| <a name="input_retention_policy"></a> [retention\_policy](#input\_retention\_policy) | Bucket retention policy. | <pre>object({<br>    retention_period = number<br>    is_locked        = bool<br>  })</pre> | `null` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Bucket storage class. | `string` | `"MULTI_REGIONAL"` | no |
| <a name="input_uniform_bucket_level_access"></a> [uniform\_bucket\_level\_access](#input\_uniform\_bucket\_level\_access) | Allow using object ACLs (false) or not (true, this is the recommended behavior) , defaults to true (which is the recommended practice, but not the behavior of storage API). | `bool` | `true` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Enable versioning, defaults to false. | `bool` | `false` | no |
| <a name="input_website"></a> [website](#input\_website) | Bucket website. | <pre>object({<br>    main_page_suffix = string<br>    not_found_page   = string<br>  })</pre> | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | Bucket resource. |
| <a name="output_id"></a> [id](#output\_id) | Bucket ID (same as name). |
| <a name="output_name"></a> [name](#output\_name) | Bucket name. |
| <a name="output_notification"></a> [notification](#output\_notification) | GCS Notification self link. |
| <a name="output_topic"></a> [topic](#output\_topic) | Topic ID used by GCS. |
| <a name="output_url"></a> [url](#output\_url) | Bucket URL. |

## Resource types
| Type | Used |
|------|-------|
| [google_pubsub_topic](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | 1 |
| [google_pubsub_topic_iam_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_binding) | 1 |
| [google_storage_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | 1 |
| [google_storage_bucket_iam_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_binding) | 1 |
| [google_storage_notification](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_notification) | 1 |
**`Used` only includes resource blocks.** `for_each` and `count` meta arguments, as well as resource blocks of modules are not considered.

## Modules

No modules.

## Resources by Files
### main.tf
| Name | Type |
|------|------|
| [google_pubsub_topic.topic](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_pubsub_topic_iam_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_binding) | resource |
| [google_storage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_binding.bindings](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_binding) | resource |
| [google_storage_notification.notification](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_notification) | resource |
<!-- END_TF_DOCS -->

## Contribute


This module is derived from [google cloud foundation fabric module `gcs` v19](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric/tree/v19.0.0/modules/gcs). It is designed to be able to integrate new changes from the base repository. Refer to [guide in `terraform-google-landing-zone` repository](https://github.com/qbeyond/terraform-google-landing-zone/tree/main#updating-a-repository) for information on integrating changes.