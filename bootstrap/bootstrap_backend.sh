#!/bin/sh
set -eu

S3NAME="cloud-pathway-terraformstate-webbase"
REGION="us-east-1"

create_bucket() {
  # us-east-1 create-bucket does NOT require LocationConstraint
  aws s3api create-bucket --bucket "$S3NAME" --region "$REGION" >/dev/null 2>&1 || true

  # Good practice for tfstate: versioning on
  aws s3api put-bucket-versioning \
    --bucket "$S3NAME" \
    --versioning-configuration Status=Enabled

  terraform init -reconfigure
  terraform apply -auto-approve
}

empty_versioned_bucket() {
  # Remove ALL versions + delete markers (required for versioned buckets)
  # This loops until AWS reports no versions/markers left.
  while :; do
    payload="$(aws s3api list-object-versions --bucket "$S3NAME" \
      --query '{Objects: (Versions[].{Key:Key,VersionId:VersionId} || `[]`) + (DeleteMarkers[].{Key:Key,VersionId:VersionId} || `[]`)}' \
      --output json)"

    # If payload is {"Objects": []} we're done
    echo "$payload" | grep -q '"Objects": \[\]' && break

    aws s3api delete-objects --bucket "$S3NAME" --delete "$payload" >/dev/null
  done
}

delete_all() {
  # Destroy infra FIRST (so terraform can still access the backend)
  terraform init -reconfigure
  terraform destroy -auto-approve

  # Then clean up the backend bucket
  aws s3api put-bucket-versioning \
    --bucket "$S3NAME" \
    --versioning-configuration Status=Suspended || true

  empty_versioned_bucket || true
  aws s3api delete-bucket --bucket "$S3NAME" --region "$REGION" || true
}

case "${1:-}" in
  delete) delete_all ;;
  *)      create_bucket ;;
esac