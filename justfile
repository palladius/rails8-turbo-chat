
list:
    just -l

doit:
    ./sbrodola3.sh 1>t.out 2>t.err

redo:
    rm -rf rubyllm_chat_app/
    just doit
