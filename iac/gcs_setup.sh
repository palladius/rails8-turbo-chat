#!/bin/bash

# This script creates and configures a Google Cloud Storage bucket for the Rails app.
# It reads the PROJECT_ID and GCS_BUCKET variables from the .env file.

set -euo pipefail

if [ ! -f .env ]; then
    echo "Error: .env file not found. Please create one with PROJECT_ID and GCS_BUCKET defined."
    exit 1
fi

# Source variables from .env file safely
set -a
source .env
set +a

if [ -z "$PROJECT_ID" ]; then
    echo "Error: PROJECT_ID is not set in the .env file."
    exit 1
fi

# Use default GCS_BUCKET if not set in .env
GCS_BUCKET=${GCS_BUCKET:-"$PROJECT_ID-rails8turbochat-assets"}
REGION=${REGION:-"europe-west1"}

echo "Using Project ID: $PROJECT_ID"
echo "Using Bucket Name: $GCS_BUCKET"
echo "Using Region: $REGION"

echo "Setting gcloud project..."
gcloud config set project "$PROJECT_ID"

echo "Creating GCS bucket..."
gsutil mb -p "$PROJECT_ID" -l "$REGION" "gs://$GCS_BUCKET" || echo 'probably it already exists'

echo "Setting uniform bucket-level access..."
gsutil uniformbucketlevelaccess set on "gs://$GCS_BUCKET"

echo "Making bucket public..."
gsutil iam ch allUsers:objectViewer "gs://$GCS_BUCKET"

echo "Creating service account..."
SA_NAME="rails8-turbo-chat-storage"
SA_EMAIL="$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"

if ! gcloud iam service-accounts describe "$SA_EMAIL" >/dev/null 2>&1; then
    echo "Service account $SA_NAME does not exist. Creating..."
    gcloud iam service-accounts create "$SA_NAME" --display-name="Rails 8 Turbo Chat Storage"
else
    echo "Service account $SA_NAME already exists."
fi

echo "Granting service account permissions..."
gsutil iam ch "serviceAccount:$SA_EMAIL:objectAdmin" "gs://$GCS_BUCKET"

echo "Creating service account key..."
gcloud iam service-accounts keys create "gcs_credentials.json" --iam-account="$SA_EMAIL"

echo "GCS bucket setup complete."
echo "Please add the following to your .env file:"
echo "GCS_CREDENTIALS_JSON='$(cat gcs_credentials.json)'"
echo gcs_credentials.json >> .gitignore
#rm gcs_credentials.json

