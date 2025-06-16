## The app

The app is under `rubyllm_chat_app/`

It also uses MCP (https://modelcontextprotocol.io/introduction)

## Dos and DONTs

* do NOT touch .env. its a private file created by me and its NOT under git. Read it, but do NOT edit it!
* do not run long running commands (like `rails server`) unless ecplicitly required to do so. Rather trust user to do so and ensure fresh logs are available somewhere for you to read (eg `log/development.log`).
* do not commit with backticks! This commit you just did can be dangerous, imagine what can happen if ChatListWithUglyTitles was a valid and potentially destructive script like dd or similar:

```bash
 git commit -am "feat: Add tool to list chats with ugly
 [...]
 Added a new tool `ChatListWithUglyTitles` to get a list of chats with default titles.
 "
```
* Do not git push before asking. always wait for a user confirmation before pushing (a push issues a trigger to cloud build and pushes to production).

## Ruby / Rails

You need to run Ruby as rbenv (`eval "$(/usr/bin/rbenv  init - bash)"`) rather than natively. Expecially in my work computers (like `derek`) i cant do gem installs ain the system, so im forced to use rbenv. I dont like rvm!

## Code enhancements

Please ensure these tasks are done:

* T001. E/R diagram present in README.md as mermaid diagram. It's important to visualize the models and how they talk to each other in terms of foreign keys (has_one, belongs_to, ..).
* T002. Document all MCP functions: prompts, tools, and so on. Put your findings in `docs/gemini/mcp.md` - see below.

## My style

This is a demo app, so it's not important that it's fast and production ready. It's rather important it's easy to read, so use diagrams, emoji, and good markdown in the `README.md`. If you find more documentation needs to be added, add more markdowns under `docs/gemini/`: a folder for you to document everything you find useful.

# URLs

* more on MCP: https://modelcontextprotocol.io/introduction

My app

🟢 Github repo 🐈🐙: https://github.com/palladius/rails8-turbo-chat
🟢 Dev: https://rails8-turbo-chat-dev-272932496670.europe-west10.run.app/
🔴 Prod: https://rails8-turbo-chat-prod-272932496670.europe-west10.run.app/
