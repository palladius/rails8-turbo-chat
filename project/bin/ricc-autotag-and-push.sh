#!/bin/bash

RICC_AUTOTAG_SCRIPT_VER="1.2_berlin"
RICC_AUTOTAG_LAST_BUILT="2025-03-18"

echo TODO ricc maybe put in rubyllmchatapp folder..

#########
# Copiato il 18mar25 da... gemini-chat (v1.1)
# +- Copied from DHH vanilla 701 (v1.0) and redone WELL.
# Using proper variables.
# Set up on Cloud Build script:
# * _GCLOUD_REGION
# * _PROJECT_ID (needed)
# * _REGION         (redundant)
# * _MESSAGGIO_OCCASIONALE (for fun)

set -euo pipefail

echo "-------------------"
echo "TAG| Welcome to $0 v$RICC_AUTOTAG_SCRIPT_VER (last built: $RICC_AUTOTAG_LAST_BUILT)"
echo "TAG| differently from my predecessors i want to dry cofnig out of here so taking it easy to get params out. thisd will fail a few times before reaching perfeccccsion".
echo "TAG| - APP_NAME: $APP_NAME"
echo "TAG| - GCLOUD_REGION: $GCLOUD_REGION"
echo "TAG| - PROJECT_ID: $PROJECT_ID"
echo "TAG| - REPONAME: berliner-docker-repo (cos its in Berlin and im fed up of having 1 docker 1 repo..)"
echo "-------------------"

#export APP_NAME='gemini-chat'

# Note the dash is in Ricc project id...
export SKAFFOLD_DEFAULT_REPO="$GCLOUD_REGION-docker.pkg.dev/$PROJECT_ID/berliner-docker-repo/$APP_NAME"
export GIT_STATE="$(git rev-list -1 HEAD --abbrev-commit)"
export GIT_COMMIT_SHA="$(git rev-parse HEAD)" # big commit
export GIT_SHORT_SHA="${GIT_COMMIT_SHA:0:7}" # first 7 chars: Riccardo reproducing what CB does for me.
export APP_VERSION="$(cat VERSION)"

set -x

echo '2. Tagging and pushing..'
docker tag "$SKAFFOLD_DEFAULT_REPO:sha-$GIT_SHORT_SHA" "$SKAFFOLD_DEFAULT_REPO:v$APP_VERSION"
docker push "$SKAFFOLD_DEFAULT_REPO" --all-tags
