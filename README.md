Self: https://github.com/palladius/rails8-turbo-chat

Try it yourself on Cloud Run: https://rails8-turbo-chat-dev-272932496670.europe-west10.run.app

# Rails8 turbo Chat

A responsive Rails chat with  `ruby_llm` Carmine's gem. With all bells and whistles to make it work on Google cloud. Just bring your own gemini API KEY!

![A red train with "rails8" writing in front. To guide it, a cute AI bot called "Gemini". The railways are detached frm ground and heading towards the sky in a big colorful Cloud, called "Google Cloud"](docs/rails8-gemini-cute.png)

Chats are saved in Activerecord (needs to be PostgreSQL for now). Conversation is rendered at chunk level, and supports **Turbo**!

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

Features:

* Since `v0.3.1`, ability to provide SSE-transport MCP functionality. Sample URL: http://localhost:8080/mcp/sse . You can test with `npx @modelcontextprotocol/inspector`


## RUN

* Use rbenv, rvm, or whatever you want really. The creator used rbenv, but this should work with any ruby setup!
*  Then enter dir and run locally: `cd  rubyllm_chat_app/ ; bin/dev`
*  This will start a service in port 8080.

# BUGS

## BU001 An error occurred: Validation failed: Content can't be blank

Currently the Gemini part doesnt work for bug with Gemini. Links:
* https://github.com/crmne/ruby_llm/issues/118
* https://github.com/crmne/ruby_llm/pull/125

## Additional info

```ruby
pry(main)> RubyLLM.models.map{|x| x.name}.select{|x| x =~ /Gemini/i}.select{|x| x =~ /image/i}
=> ["Gemini 2.0 Flash Preview Image Generation"]
```

## Enviropnments

As of 0.8.15, we have a fourth env which is dev for GCP called `cloud-dev`. So the config is like this:

normal use:
* `development`: sqlite3, local storage
* `cloud-dev`: sqlite3, GCS
* `production`: proper PostgreS, GCS

`docker-compose`:
* ENv=`development`, fake docker local PostgreSQL.
