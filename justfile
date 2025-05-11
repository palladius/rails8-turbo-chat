
list:
    just -l

doit:
    ./sbrodola3.sh 1>t.out 2>t.err

redo:
    rm -rf rubyllm_chat_app/
    just doit

clone-carmine:
    git clone https://github.com/crmne/ruby_llm ruby_llm-copy/
