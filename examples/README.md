# Cloud Identity

To use this example, it is required to enable the cloudidentity service in your project.\
When using user credentials instead of a service_account, make sure you set\
user_project_override = true and billing_project to your desired billing project.\

Furthermore it is necessary to have permissions on your organizations level. \
You can add permissions to your account via https://admin.google.com .\

To use an existing encryption key, you have to grant permission to your Cloud Storage Agent \
which is automated by Terraform. \

The Key and the Bucket must be in the same location!