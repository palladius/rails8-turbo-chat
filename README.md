Self: https://github.com/palladius/rails8-turbo-chat

# rails8-turbo-chat

A responsive Rails chat with  `ruby_llm` Carmine's gem. With all bells and whistles to make it work on Google cloud.
Just bring your own gemini API KEY!

![A red train with "rails8" writing in front. To guide it, a cute AI bot called "Gemini". The railways are detached frm ground and heading towards the sky in a big colorful Cloud, called "Google Cloud"](docs/rails8-gemini-cute.png)


* 📆 Created: `19apr2025`. Written by Google with a `sbrodola.sh` script.
* 🪞 Self: **PUBLIC** - github 🐙🐱 `palladius/rails8-turbo-chat.git`
* 🟦 GDoc: go/ricc-rails8 - go/pbt-rails8
* 💎 Gems:
    * ♦️ `ruby_llm` (from git) 🤖 - The core engine for all the cool Large Language Model magic!
    * ♦️ `devise` 🔑 - Handles all the user sign-up and login stuff, a real timesaver.
    * ♦️ `dotenv-rails` 🤫 - Manages environment variables, keeping secrets out of the code.
    * ♦️ `pry` & `pry-rails` 🕵️‍♂️ - My trusty debugging combo, lets me dive into the Rails console and poke around.
    * ♦️ `kramdown` & `kramdown-parser-gfm` 📝 - For making Markdown look pretty, especially with GitHub flavors.
    * ♦️ `rainbow` 🌈 - Adds a splash of color to terminal output, makes things easier to read!

## RUN

```bash
# enter dir
cd  rubyllm_chat_app/
# run locally
bin/dev
```

# BUGS

## BU001 An error occurred: Validation failed: Content can't be blank

Currently the Gemini part doesnt work for bug with Gemini. Links:
* https://github.com/crmne/ruby_llm/issues/118
* https://github.com/crmne/ruby_llm/pull/125
