#!/bin/bash

set -euo pipefail


echo 1. Fixing CB dflt SA - medium
gcloud projects add-iam-policy-binding palladius-genai \
    --member="serviceAccount:272932496670@cloudbuild.gserviceaccount.com" \
    --role="roles/pubsub.publisher" \
    --role="roles/source.reader" \
    --role="roles/logging.logWriter" \
    --role="roles/artifactregistry.writer"

echo 2. Fixing Compute dflt SA - powerful
gcloud projects add-iam-policy-binding palladius-genai \
    --member="serviceAccount:272932496670-compute@developer.gserviceaccount.com" \
    --role="roles/pubsub.publisher" \
    --role="roles/source.reader" \
    --role="roles/logging.logWriter" \
    --role="roles/artifactregistry.writer"
verde ok

# INFO: The legacy Cloud Build service account 272932496670@cloudbuild.gserviceaccount.com
# running this build does not have permission(s) to execute the build. To fix this, grant the following permission(s) to the service account:
# [pubsub.topics.publish source.repos.get source.repos.list logging.logEntries.create]
