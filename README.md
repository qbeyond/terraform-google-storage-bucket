# Google Cloud Storage Module

## TODO

- [ ] add support for defining [notifications](https://www.terraform.io/docs/providers/google/r/storage_notification.html)

## Example

```hcl
module "bucket" {
  source     = "./modules/gcs"
  project_id = "myproject"
  prefix     = "test"
  name       = "my-bucket"
  iam_members = {
    "roles/storage.admin" = ["group:storage@example.com"]
  }
}
```

### Example with Cloud KMS

```hcl
module "bucket" {
  source     = "./modules/gcs"
  project_id = "myproject"
  prefix     = "test"
  name       = "my-bucket"
  iam_members = {
    "roles/storage.admin" = ["group:storage@example.com"]
  }
  encryption_keys = local.kms_key.self_link
}
```

### Example with retention policy

```hcl
module "bucket" {
  source     = "./modules/gcs"
  project_id = "myproject"
  prefix     = "test"
  name       = "my-bucket"
  iam_members = {
    "roles/storage.admin" = ["group:storage@example.com"]
  }

  retention_policies = {
    retention_period = 100
    is_locked        = true
  }

  logging_config = {
    log_bucket        = bucket_name_for_logging
    log_object_prefix = null
  }
}
```

<!-- BEGIN TFDOC -->
## Variables

| name | description | type | required | default |
|---|---|:---: |:---:|:---:|
| name | Bucket name suffix. | <code title="">string</code> | ✓ |  |
| project_id | Bucket project id. | <code title="">string</code> | ✓ |  |
| *encryption_key* | KMS key that will be used for encryption. | <code title="">string</code> |  | <code title="">null</code> |
| *force_destroy* | Optional map to set force destroy keyed by name, defaults to false. | <code title="">bool</code> |  | <code title="">false</code> |
| *iam_members* | IAM members keyed by bucket name and role. | <code title="map&#40;set&#40;string&#41;&#41;">map(set(string))</code> |  | <code title="">{}</code> |
| *labels* | Labels to be attached to all buckets. | <code title="map&#40;string&#41;">map(string)</code> |  | <code title="">{}</code> |
| *location* | Bucket location. | <code title="">string</code> |  | <code title="">EU</code> |
| *logging_config* | Bucket logging configuration. | <code title="object&#40;&#123;&#10;log_bucket        &#61; string&#10;log_object_prefix &#61; string&#10;&#125;&#41;">object({...})</code> |  | <code title="">null</code> |
| *prefix* | Prefix used to generate the bucket name. | <code title="">string</code> |  | <code title="">null</code> |
| *retention_policy* | Bucket retention policy. | <code title="object&#40;&#123;&#10;retention_period &#61; number&#10;is_locked        &#61; bool&#10;&#125;&#41;">object({...})</code> |  | <code title="">null</code> |
| *storage_class* | Bucket storage class. | <code title="">string</code> |  | <code title="">MULTI_REGIONAL</code> |
| *uniform_bucket_level_access* | Allow using object ACLs (false) or not (true, this is the recommended behavior) , defaults to true (which is the recommended practice, but not the behavior of storage API). | <code title="">bool</code> |  | <code title="">true</code> |
| *versioning* | Enable versioning, defaults to false. | <code title="">bool</code> |  | <code title="">false</code> |

## Outputs

| name | description | sensitive |
|---|---|:---:|
| bucket | Bucket resource. |  |
| name | Bucket name. |  |
| url | Bucket URL. |  |
<!-- END TFDOC -->
