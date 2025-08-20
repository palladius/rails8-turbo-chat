list:
    just -l

doit:
    ./sbrodola3.sh 1>t.out 2>t.err

redo:
    rm -rf rubyllm_chat_app/
    just doit

clone-carmine:
    git clone https://github.com/crmne/ruby_llm ruby_llm-copy/


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
    cat 'docs/prompts/ui/03-ensure-dev-prod-versions-aligned.md' | \
        time gemini --yolo --prompt
