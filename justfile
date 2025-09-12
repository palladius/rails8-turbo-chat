
set dotenv-load := true

# Disable this if the file doesn't exist. This works for Riccardo, sorry!
import '~/git/gic/justfile.gemini_common'

list:
    just -l
    @echo "🌱 PROJECT_ID: ${PROJECT_ID}"
    @echo "🌱 GCS_BUCKET: ${GCS_BUCKET}"


# CB_SUBSTITUTIONS=_RAILS_MASTER_KEY="YOUR_RAILS_MASTER_KEY_HERE",_GEMINI_API_KEY="YOUR_GEMINI_API_KEY_HERE"
# [Cloud Build] submit local target
# cloudbuild-submit:
#     gcloud builds submit .   --config cloudbuild.yaml   --substitutions="$CB_SUBSTITUTIONS"


derek-fix-gems:
    echo sic ait Gemini Gloria Gaynor mundi:

    gem cleanup stringio
    # => works fast

    gem pristine --all
    # => works SLOWWWW

    # step 3.
    gem install foreman # If not already handled by bundle install
    rbenv rehash



dev:
    cd app && just dev

# tests the forbidden origin MCP error oneliner.
test-mcp-remote:
    curl https://rails8-turbo-chat-dev-272932496670.europe-west10.run.app/mcp/sse

mcp-server-local:
    echo "Try giving this: SEE // http://localhost:8080/mcp/sse"

ruby-check:
    @echo "♦️  Checking Ruby version... This is only meaningful in dev environment."
    @echo ♦️♦️  1. Ruby without rbenv magic:
    ruby --version
    @echo ♦️♦️  2. Ruby with rbenv magic:
    eval "$(rbenv init -)" && ruby --version

llm-check:
    cd app && echo "RubyLLM.chat.ask 'ciao'" | rails c

# [magic] Test UI from main dir (maybe should be from sub dir?)
test-ui:
    ./run_ui_tests.sh

auth:
    gcloud auth login

list-assets:
    #!/bin/bash
    set -euo pipefail
    source .env
    gsutil ls -r gs://$GCS_BUCKET/**

generate-image-for-chat:
    #!/bin/bash
    set -euo pipefail
    source .env
    echo "Generating image for chat #40..."
    cd rubyllm_chat_app/
    DATABASE_URL=$DATABASE_URL_DEV rails runner "script/generate_image_for_chat.rb" 40
    echo "Generation script finished."

test-builds:
    cat 'docs/prompts/ui/03-ensure-dev-prod-versions-aligned.md' | gemini --yolo --prompt

## Copied from apps-portfolio - note project id is written here -> UGLY
# List latest 10 CB builds, possible the first might still be running
cloud-build-list:
    gcloud builds list --project=palladius-genai --limit=10

# Show the log of a specific Cloud Build, eg 7c82188e-485a-4735-a70d-fb303fbfe5a0
cloud-build-show-log build_id:
    @echo "Showing log for build ID: {{build_id}}. Use --stream to follow the log indefinitely (you can do it, but I want Gemini NOT to do it)."
    gcloud builds log {{build_id}} --project=palladius-genai

cloud-run-dev-logs:
    @echo "☁️  Fetching logs for Cloud Run dev environment..."
    gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=rails8-turbo-chat-dev" --project='palladius-genai' --limit=100 --format="value(timestamp, severity, textPayload)"

cloud-run-prod-logs:
    @echo "☁️  Fetching logs for Cloud Run prod environment..."
    gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=rails8-turbo-chat-prod" --project='palladius-genai' --limit=100 --format="value(timestamp, severity, textPayload)"

test:
    echo TODO not now Riccardo. We need to figure out a fungible PostgreSQL DB in test, maybe in localhost, maybe in test?


# New Gemini feature from 28aug25 - auto edit!
gemini:
    gemini -c --approval-mode auto_edit

# Shows git logs in timestamped way
git-logs-timestamped:
    git log --pretty=format:'%h %ad | %s%d [%an]' --date=iso -n 10
