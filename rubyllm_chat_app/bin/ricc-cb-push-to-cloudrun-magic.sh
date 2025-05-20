#!/bin/bash

#####################################################################################################
# Runs both DEV and PROD
# Usage: $0 <dev|prod>
#
#Wrong:
# expected: Image 'europe-west1-docker.pkg.dev/palladius-genai/gemini-chat-manhouse/gemini-chat-manhouse:latest' not found.
#  reality:        europe-west1-docker.pkg.dev/palladius-genai/gemini-chat/gemini-chat

# copiato da gemini-chat il 18mar25
RICC_CBPUSH_SCRIPT_VER="1.3"
RICC_CBPUSH_LAST_BUILT="2025-03-18"

export DEPLOY_VERSION='2.0.9b'
# 19mar25  2.0.9       added GEMINI_API_KEY - (b) anche GIT_LADST_COMMIT
# 18mar25  2.0.8       refactored everything..
# 02jun24  2.0.7       Removed bunch of vars, since im moving 99% of them to RAC (for DRY reasons)
# 02jun24  2.0.6       Copied from gemini-news 2.0.5 and branched even since.
# 31may24  2.0.5       Added ENV[RUBY_YJIT_ENABLE]=true - should compile stuff faster now.
# 19may24  2.0.4buggy  Added ENV[PALM_API_KEY_GEMINI] - should fix PalmLLM. Note I used GEMINI_KEY for since  PALM_API_KEY_GEMINI is actually not in
#                      my Secret Manager (yet and its late at night and my mum waas the room)
# 17may24  2.0.3       Added project_id
#####################################################################################################

function _usage() {
  echo "Usage: $0 [dev|prod] [latest]"
  exit 142
}

# These variables I need to know BEFORE the dev vs PROD part. Or maybe I can skip to aftr them
################################################
# ENV set
################################################
export DOLL1=${1:-NONE}

set -euo pipefail

#export APP_NAME='gemini-chat'
export AR_NAME="$APP_NAME"
export APP_NAME_TO_DEPLOY="$APP_NAME"
echo "------------------------------------------------------------------------"
echo "CBPUSH| Welcome to $0 v$RICC_CBPUSH_SCRIPT_VER (last built: $RICC_CBPUSH_LAST_BUILT)"
echo "CBPUSH| This should be valid: APP_NAME=$APP_NAME"
echo "CBPUSH| This should be valid: GCLOUD_REGION=$GCLOUD_REGION"
echo "------------------------------------------------------------------------"

export PORT=8080
export GCLOUD_REGION="${GCLOUD_REGION:-europe-west10}"
export GIT_STATE="$(git rev-list -1 HEAD --abbrev-commit)"
export GIT_COMMIT_SHA="$(git rev-parse HEAD)" # big commit
export GIT_SHORT_SHA="${GIT_COMMIT_SHA:0:7}" # first 7 chars: Riccardo reproducing what CB does for me.
export GIT_LAST_COMMENT="$(git log -1 --pretty=%B)"
export MY_APP_VERSION="$(cat VERSION)"
# Can be overridden by $2..
export APP_VERSION="${2:-$MY_APP_VERSION}"
#export APP_VERSION_LATEST="latest"
export MESSAGGIO_OCCASIONALE="MsgOcc Non datur in MAGIC"
export RAILS_MASTER_KEY="${RAILS_MASTER_KEY:-foobarbaz}"
export BUCKET="${BUCKET:-bucket-non-datur}"
export ENABLE_GCP='false'
export MY_REGIONAL_SUBNET="projects/$PROJECT_ID/regions/$GCLOUD_REGION/subnetworks/default"

# Change AppName if deployed from Carlessian computer
# if hostname | egrep 'ricc-macbookpro|derek|penguin' ; then
#   #echo 'I believe this code wont work given how BASH vars suck '
#   export APP_NAME_TO_DEPLOY="$APP_NAME-manhouse"
# fi

# Check dev or prod
case "$DOLL1" in
   dev | development )
    export APP_TO_DEPLOY="${APP_NAME_TO_DEPLOY}-dev"
    export RAILS_ENV=development
    ;;

  prod | production )
    export APP_TO_DEPLOY="${APP_NAME_TO_DEPLOY}-prod"
    export RAILS_ENV=production
    ;;
  just | justfile | manhouse | NONE )
    export APP_TO_DEPLOY="${APP_NAME_TO_DEPLOY}-manhouse"
    export RAILS_ENV=development
    ;;
  *) # else
    _usage
    ;;
esac


set -euo pipefail


# get from secret manager
#SECRET_REGION=$(gcloud secrets versions access latest --secret=gemini-chat_REGION)

# Derived info
CLOUDRUN_PROJECT_ID="$PROJECT_ID"
# VER non lo posso calcolare da CB vanilla, serve un shell script :/
           UPLOADED_IMAGE_WITH_VER="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/berliner-docker-repo/${AR_NAME}:v$APP_VERSION"
UPLOADED_IMAGE_WITH_LATEST_VERSION="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/berliner-docker-repo/${AR_NAME}:latest"
           UPLOADED_IMAGE_WITH_SHA="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/berliner-docker-repo/${AR_NAME}:sha-$GIT_SHORT_SHA"

# $1 can be unbound
if [ latest = "${2:-sthElse}" ]; then
  echo '🗞️ Overriding both SHA/VER to LATEST (or whatever DOLL1 says) since you gave me DOLL1:'
  export UPLOADED_IMAGE_WITH_SHA="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/berliner-docker-repo/${AR_NAME}:latest"
  export UPLOADED_IMAGE_WITH_VER="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/berliner-docker-repo/${AR_NAME}:latest"
else
  echo You didnt give me any DOLL_2.. continuing
fi

echo "---- DEBUG  ----"
echo "+ PROJECT_ID: $PROJECT_ID"
echo "+ DEPLOY_VERSION: $DEPLOY_VERSION"
echo "+ APP_VERSION:    $APP_VERSION"
echo "+ GIT_SHORT_SHA:  $GIT_SHORT_SHA"
echo "+ UPL_IMG_W/_SHA: $UPLOADED_IMAGE_WITH_SHA"
echo "+ UPLOADED_IMAGE_WITH_VER: $UPLOADED_IMAGE_WITH_VER"
echo "+ APP_TO_DEPLOY: $APP_TO_DEPLOY"
echo "+ DATABASE_URL: ${DATABASE_URL}"
echo "+ DATABASE_URL_DEV: ${DATABASE_URL_DEV:-NonDatur}"
echo "✅ GEMINI_API_KEY (new): $GEMINI_API_KEY"
echo "✅ GIT_LAST_COMMENT (new): $GIT_LAST_COMMENT"
echo "✅ PORT (new): ${PORT:-nOnDatur}"
echo "---- /DEBUG ----"

set -x


echo 'WARNING: For this to work you need to 1. upload your ENVRC to Secret MAnager 2. make the SA able to access SM and 3. call it properly.'

#########
# DEV
# Uses: DATABASE_URL_DEV
# TODO when it works delete DATABASE_blah
# I'm too dumb to use DEV and PROD at same time DATABASE_URL_DEV and DATABASE_URL_PROD
# but its not too simple to fix.
#########
# Riccardo in europe-west1 - TODO move to ENV stuff
# Redis: 10.103.87.131:6379

# Removed  --set-env-vars="ALLOWED_ORIGINS=$ALLOWED_ORIGINS" \
# See 0.3.9 error in CHANGELOG.md

gcloud --project "$CLOUDRUN_PROJECT_ID" \
    beta run deploy "$APP_TO_DEPLOY" \
      --image  "$UPLOADED_IMAGE_WITH_VER" \
      --platform managed \
      --memory "3072Mi" \
      --region "$GCLOUD_REGION" \
      --set-env-vars='description=created-from-bin-slash-cb-push-to-cloudrun-sh' \
      --set-env-vars="GIT_STATE=$GIT_STATE" \
      --set-env-vars="APP_VERSION=$APP_VERSION" \
      --set-env-vars="DATABASE_URL=$DATABASE_URL" \
      --set-env-vars="RAILS_MASTER_KEY=$RAILS_MASTER_KEY" \
      --set-env-vars="RAILS_ENV=$RAILS_ENV" \
      --set-env-vars="RAILS_SERVE_STATIC_FILES=true" \
      --set-env-vars="MESSAGGIO_OCCASIONALE=$MESSAGGIO_OCCASIONALE" \
      --set-env-vars="RAILS_LOG_TO_STDOUT=yesplease" \
      --set-env-vars="PROJECT_ID=$PROJECT_ID" \
      --set-env-vars="RUBY_YJIT_ENABLE=true" \
      --set-env-vars="GEMINI_API_KEY=$GEMINI_API_KEY" \
      --set-env-vars="GIT_LAST_COMMENT=$GIT_LAST_COMMENT" \
      --set-env-vars=ENABLE_GCP='true' \
      --set-env-vars=APP_NAME="$APP_NAME" \
      --allow-unauthenticated

#       --set-env-vars="DATABASE_URL_PROD=$DATABASE_URL_PROD" \
#      --network=default \
#      --set-env-vars="REDIS_URL=$RICCARDO_REDIS_URL" \
#      --subnet="$MY_REGIONAL_SUBNET" \

# Non li uso al momento.
#      --set-env-vars="GEMINI_KEY=$GEMINI_KEY" \
# --set-env-vars=GCP_KEY_PATH_FROM_WEBAPP="/geminews-key/geminews-key" \
# --set-secrets="/secretenvrc/gemini-chat-envrc=gemini-chat-envrc:latest" \
# --set-secrets="/geminews-key/geminews-key=geminews-key:latest" \


# Dubito serva:       --set-env-vars="SECRET_KEY_BASE=TODO" \

# ILLEGAL       --set-env-vars="PORT=8080" \
#      --update-secrets=gemini-chat_SECRET_KEY=gemini-chat_SECRET_KEY:latest \
#      --service-account="gemini-chat-docker-runner@$PROJECT_ID.iam.gserviceaccount.com" \
# Useless:
# --set-env-vars="BUCKET=$BUCKET" \
# --set-env-vars="DATABASE_HOST=$DATABASE_HOST" \
# --set-env-vars="DATABASE_NAME=$DATABASE_NAME" \
# --set-env-vars="DATABASE_USER=$DATABASE_USER" \
# --set-env-vars="DATABASE_PASS=$DATABASE_PASS" \


# make sure we exit 0 with a string (set -e guarantees this)
echo All is Done.
