
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
