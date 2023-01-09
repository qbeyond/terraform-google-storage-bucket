# Google Cloud Storage Module
Original Module from [Cloud-Foundation-Fabric](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric)

## Example

```hcl
module "bucket" {
  source     = "./fabric/modules/gcs"
  project_id = "myproject"
  prefix     = "test"
  name       = "my-bucket"
  iam = {
    "roles/storage.admin" = ["group:storage@example.com"]
  }
}
# tftest modules=1 resources=2
```

### Example with Cloud KMS

```hcl
module "bucket" {
  source     = "./fabric/modules/gcs"
  project_id = "myproject"
  prefix     = "test"
  name       = "my-bucket"
  iam = {
    "roles/storage.admin" = ["group:storage@example.com"]
  }
  encryption_key = "my-encryption-key"
}
# tftest modules=1 resources=2
```

### Example with retention policy

```hcl
module "bucket" {
  source     = "./fabric/modules/gcs"
  project_id = "myproject"
  prefix     = "test"
  name       = "my-bucket"
  iam = {
    "roles/storage.admin" = ["group:storage@example.com"]
  }

  retention_policy = {
    retention_period = 100
    is_locked        = true
  }

  logging_config = {
    log_bucket        = var.bucket
    log_object_prefix = null
  }
}
# tftest modules=1 resources=2
```

### Example with lifecycle rule

```hcl
module "bucket" {
  source     = "./fabric/modules/gcs"
  project_id = "myproject"
  prefix     = "test"
  name      = "my-bucket"

  iam = {
    "roles/storage.admin" = ["group:storage@example.com"]
  }

  lifecycle_rule = {
    action = {
      type          = "SetStorageClass"
      storage_class = "STANDARD"
    }
    condition = {
      age                        = 30
      created_before             = null
      with_state                 = null
      matches_storage_class      = null
      num_newer_versions         = null
      custom_time_before         = null
      days_since_custom_time     = null
      days_since_noncurrent_time = null
      noncurrent_time_before     = null
    }
  }
}
# tftest modules=1 resources=2
```
### Minimal example with GCS notifications
```hcl
module "bucket-gcs-notification" {
  source     = "./fabric/modules/gcs"
  project_id = "myproject"
  prefix     = "test"
  name       = "my-bucket"
  notification_config = {
    enabled           = true
    payload_format    = "JSON_API_V1"
    sa_email          = "service-<project-number>@gs-project-accounts.iam.gserviceaccount.com" # GCS SA email must be passed or fetched from projects module.
    topic_name        = "gcs-notification-topic"
    event_types       = ["OBJECT_FINALIZE"]
    custom_attributes = {}
  }
}
# tftest modules=1 resources=4
```
<!-- BEGIN TFDOC -->

## Variables

| name | description | type | required | default |
|---|---|:---:|:---:|:---:|
| [name](variables.tf#L89) | Bucket name suffix. | <code>string</code> | ✓ |  |
| [project_id](variables.tf#L117) | Bucket project id. | <code>string</code> | ✓ |  |
| [cors](variables.tf#L17) | CORS configuration for the bucket. Defaults to null. | <code title="object&#40;&#123;&#10;  origin          &#61; list&#40;string&#41;&#10;  method          &#61; list&#40;string&#41;&#10;  response_header &#61; list&#40;string&#41;&#10;  max_age_seconds &#61; number&#10;&#125;&#41;">object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code>null</code> |
| [encryption_key](variables.tf#L28) | KMS key that will be used for encryption. | <code>string</code> |  | <code>null</code> |
| [force_destroy](variables.tf#L34) | Optional map to set force destroy keyed by name, defaults to false. | <code>bool</code> |  | <code>false</code> |
| [iam](variables.tf#L40) | IAM bindings in {ROLE => [MEMBERS]} format. | <code>map&#40;list&#40;string&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [labels](variables.tf#L46) | Labels to be attached to all buckets. | <code>map&#40;string&#41;</code> |  | <code>&#123;&#125;</code> |
| [lifecycle_rule](variables.tf#L52) | Bucket lifecycle rule. | <code title="object&#40;&#123;&#10;  action &#61; object&#40;&#123;&#10;    type          &#61; string&#10;    storage_class &#61; string&#10;  &#125;&#41;&#10;  condition &#61; object&#40;&#123;&#10;    age                        &#61; number&#10;    created_before             &#61; string&#10;    with_state                 &#61; string&#10;    matches_storage_class      &#61; list&#40;string&#41;&#10;    num_newer_versions         &#61; string&#10;    custom_time_before         &#61; string&#10;    days_since_custom_time     &#61; string&#10;    days_since_noncurrent_time &#61; string&#10;    noncurrent_time_before     &#61; string&#10;  &#125;&#41;&#10;&#125;&#41;">object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code>null</code> |
| [location](variables.tf#L74) | Bucket location. | <code>string</code> |  | <code>&#34;EU&#34;</code> |
| [logging_config](variables.tf#L80) | Bucket logging configuration. | <code title="object&#40;&#123;&#10;  log_bucket        &#61; string&#10;  log_object_prefix &#61; string&#10;&#125;&#41;">object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code>null</code> |
| [notification_config](variables.tf#L94) | GCS Notification configuration. | <code title="object&#40;&#123;&#10;  enabled           &#61; bool&#10;  payload_format    &#61; string&#10;  topic_name        &#61; string&#10;  sa_email          &#61; string&#10;  event_types       &#61; list&#40;string&#41;&#10;  custom_attributes &#61; map&#40;string&#41;&#10;&#125;&#41;">object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code>null</code> |
| [prefix](variables.tf#L107) | Optional prefix used to generate the bucket name. | <code>string</code> |  | <code>null</code> |
| [retention_policy](variables.tf#L122) | Bucket retention policy. | <code title="object&#40;&#123;&#10;  retention_period &#61; number&#10;  is_locked        &#61; bool&#10;&#125;&#41;">object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code>null</code> |
| [storage_class](variables.tf#L131) | Bucket storage class. | <code>string</code> |  | <code>&#34;MULTI_REGIONAL&#34;</code> |
| [uniform_bucket_level_access](variables.tf#L141) | Allow using object ACLs (false) or not (true, this is the recommended behavior) , defaults to true (which is the recommended practice, but not the behavior of storage API). | <code>bool</code> |  | <code>true</code> |
| [versioning](variables.tf#L147) | Enable versioning, defaults to false. | <code>bool</code> |  | <code>false</code> |
| [website](variables.tf#L153) | Bucket website. | <code title="object&#40;&#123;&#10;  main_page_suffix &#61; string&#10;  not_found_page   &#61; string&#10;&#125;&#41;">object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code>null</code> |

## Outputs

| name | description | sensitive |
|---|---|:---:|
| [bucket](outputs.tf#L17) | Bucket resource. |  |
| [id](outputs.tf#L28) | Bucket ID (same as name). |  |
| [name](outputs.tf#L37) | Bucket name. |  |
| [notification](outputs.tf#L46) | GCS Notification self link. |  |
| [topic](outputs.tf#L51) | Topic ID used by GCS. |  |
| [url](outputs.tf#L56) | Bucket URL. |  |

<!-- END TFDOC -->

## Contribute


This module is derived from [google cloud foundation fabric module `gcs` v19](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric/tree/v19.0.0/modules/gcs). It is designed to be able to integrate new changes from the base repository. Refer to [guide in `terraform-google-landing-zone` repository](https://github.com/qbeyond/terraform-google-landing-zone/tree/main#updating-a-repository) for information on integrating changes.
<!-- BEGIN_TF_DOCS -->
## Usage

This Module creates a GCP Storage Bucket
```hcl
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