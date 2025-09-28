
set dotenv-load := true

# Disable this if the file doesn't exist. This works for Riccardo, sorry!
#import '~/git/gic/justfile.gemini_common'
import 'justfile.workshop'
import 'justfile.google_cloud'

list:
    just -l
    @echo "🌱 PROJECT_ID: ${PROJECT_ID}"
    @echo "🌱 GCS_BUCKET: ${GCS_BUCKET}"




# derek-fix-gems:
#     echo sic ait Gemini Gloria Gaynor mundi:

#     gem cleanup stringio
#     # => works fast

#     gem pristine --all
#     # => works SLOWWWW

#     # step 3.
#     gem install foreman # If not already handled by bundle install
#     # rbenv rehash



dev:
    cd rubyllm_chat_app/ && just dev

# tests the forbidden origin MCP error oneliner.
test-mcp-remote:
    curl https://rails8-turbo-chat-dev-272932496670.europe-west10.run.app/mcp/sse

mcp-server-local:
    echo "Try giving this: SEE // http://localhost:8080/mcp/sse"

ruby-check:
    @echo "♦️  Checking Ruby version... This is only meaningful in dev environment."
    @echo ♦️♦️  Ruby version:
    ruby --version

llm-check:
    cd app && echo "RubyLLM.chat.ask 'ciao'" | rails c

# [magic] Test UI from main dir (maybe should be from sub dir?)
test-ui:
    ./run_ui_tests.sh


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
    cd project/
    bundle exec rails runner "script/generate_image_for_chat.rb" 40
    echo "Generation script finished."

test-builds:
    cat 'docs/prompts/ui/03-ensure-dev-prod-versions-aligned.md' | gemini --yolo --prompt

# test:
#     echo TODO not now Riccardo. We need to figure out a fungible PostgreSQL DB in test, maybe in localhost, maybe in test?


# New Gemini feature from 28aug25 - auto edit!
gemini2:
    gemini -c --approval-mode auto_edit

# Shows git logs in timestamped way
git-logs-timestamped:
    git log --pretty=format:'%h %ad | %s%d [%an]' --date=iso -n 10

# Clones Chris fork
rails8-turbo-chat-chris:
    git clone https://github.com/a-chris/rails8-turbo-chat rails8-turbo-chat-chris
