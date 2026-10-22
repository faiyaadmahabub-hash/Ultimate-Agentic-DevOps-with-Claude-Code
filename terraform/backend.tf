# Remote state backend
#
# Setup steps:
#   1. Run `terraform init` with this block commented out (as below) and
#      `terraform apply` to create your state bucket (and DynamoDB lock
#      table, if you use one) through some other means, or a separate
#      bootstrap configuration.
#   2. Uncomment the backend block below and fill in your bucket name/key.
#   3. Run `terraform init -migrate-state` to move local state into S3.

# terraform {
#   backend "s3" {
#     bucket       = "your-terraform-state-bucket"
#     key          = "portfolio-site/terraform.tfstate"
#     region       = "ap-south-1"
#     encrypt      = true
#     use_lockfile = true
#   }
# }
