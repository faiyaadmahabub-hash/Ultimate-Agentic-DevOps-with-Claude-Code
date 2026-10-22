---
name: project-portfolio-tf-state
description: Current state of terraform/ directory in the static portfolio site repo as of 2026-10-22 audit
metadata:
  type: project
---

Repo has 5 .tf files under `terraform/`: main.tf, providers.tf, variables.tf, outputs.tf, backend.tf. Resources: aws_s3_bucket.site, aws_s3_bucket_public_access_block.site, aws_cloudfront_origin_access_control.site (OAC, correctly used), aws_s3_bucket_policy.site (scoped to CloudFront service principal with SourceArn condition — good least privilege pattern), aws_cloudfront_distribution.site.

Known gaps found in 2026-10-22 audit (still present unless fixed later):
- No aws_s3_bucket_server_side_encryption_configuration resource — bucket has no encryption-at-rest config.
- No aws_s3_bucket_versioning resource.
- No access logging (no aws_s3_bucket_logging, no CloudFront `logging_config` block).
- backend.tf has remote S3 backend fully commented out — state is local by default, no locking/encryption configured. This is intentional scaffolding (see comments) but should be flagged every audit until enabled.
- CloudFront `viewer_certificate` uses `cloudfront_default_certificate = true` (shared *.cloudfront.net cert, TLS1.0/legacy-compatible by default) — fine only if no custom domain is used; variable `domain_name` exists but is unused in main.tf, suggesting custom domain + ACM cert + minimum_protocol_version TLSv1.2_2021 is a planned but unimplemented feature.
- No security response headers policy (aws_cloudfront_response_headers_policy) attached to the distribution — missing CSP/X-Frame-Options/HSTS.
- No IAM OIDC/GitHub Actions trust policy resources exist yet in this repo (no aws_iam_openid_connect_provider or aws_iam_role found) — if added later, must scope `token.actions.githubusercontent.com:sub` to specific repo:ref, not wildcard.

How to apply: On future audits, check whether these gaps have been remediated before re-reporting them as new findings; diff against this snapshot rather than re-deriving from scratch every time.
