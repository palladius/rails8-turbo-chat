## The app

The Rails 8 app is under `rubyllm_chat_app/` (symlinked by `app/`)

It also uses MCP (https://modelcontextprotocol.io/introduction)

## Dos and DON'Ts

* Do NOT touch `.env`. It's a private file created by me and it's NOT under git. Read it, but do NOT edit it!
* Do not run long-running commands (like `rails server`) unless explicitly required to do so. Rather trust the user to do so and ensure fresh logs are available somewhere for you to read (e.g., `rubyllm_chat_app/log/development.log`).
* Do not commit with backticks! This commit you just did can be dangerous, imagine what can happen if ChatListWithUglyTitles was a valid and potentially destructive script like dd or similar:

```bash
 git commit -am "feat: Add tool to list chats with ugly
 [...]
 Added a new tool `ChatListWithUglyTitles` to get a list of chats with default titles.
 "
```
* Do not git push before asking. Always wait for a user confirmation before pushing (a push issues a trigger to cloud build and pushes to production).
* Databases: do NOT use DEV Database for PROD or TEST, or vice-versa. We should have THREE databases, one for test, dev and prod. Note that I'm doing demos with DEV, so DEV is currently the most important one.
* Do NOT run `just dev`!! I run it for you and you just read logs in `rubyllm_chat_app/log/`. If you find the app is not running, ask me (the user) to run it for you.
    * Check if the APP is running by curling `localhost` on port `8080`.


## Ruby / Rails

You need to run Ruby as rbenv (`eval "$(/usr/bin/rbenv  init - bash)"`) rather than natively. Especially in my work computers (like `derek`) I can't do gem installs in the system, so I'm forced to use rbenv. I don't like rvm!

## Code enhancements

Please ensure these tasks are done:

* T001. E/R diagram present in README.md as mermaid diagram. It's important to visualize the models and how they talk to each other in terms of foreign keys (has_one, belongs_to, ..).
* T002. Document all MCP functions: prompts, tools, and so on. Put your findings in `docs/gemini/mcp.md` - see below.

## My style

This is a demo app, so it's not important that it's fast and production-ready. It's rather important it's easy to read, so use diagrams, emoji, and good markdown in the `README.md`. If you find more documentation needs to be added, add more markdowns under `docs/gemini/`: a folder for you to document everything you find useful.

# URLs

* more on MCP: https://modelcontextprotocol.io/introduction (use context7 if available)

My app

🟢 Github repo 🐈🐙: https://github.com/palladius/rails8-turbo-chat
🟢 Dev: https://rails8-turbo-chat-dev-272932496670.europe-west10.run.app/
🔴 Prod: https://rails8-turbo-chat-prod-272932496670.europe-west10.run.app/


## Casa sab4jul

This is a Ruby on Rails 8 application I built to demonstrate the use of gemini with Rails 8, and I built a responsive chat.

I'm NOT good at JS, just at Ruby. Help me navigate the JavaScript/Responsiveness in this project.

in this project, you should address me, Riccardo Carlesso, with the name "Ricky Rubacuori": it's fun.

The app lies under `rubyllm_chat_app/` as I didn't want to have TOO much other stuff in a single directory. Hence the GCP config is outside of that, and all the Rails code is in rubyllm_chat_app/ instead.

## Feedback loop

* **App**: When working on this app, I'm invoking for you `just dev`. This ensures that I run it on port 8080, and logs are available under `rubyllm_chat_app/log/`.
* **DB**: for access to DB you can use convenience commands like "echo Chat.all.count | rails console". This will allow you to programmatically ask for all chats.

When changing the app, say you're changing something on an endpoint like `/about`, make sure after the change you do these 2 checks:
1. curl http://localhost:8080/about to check it returns 200. If not, check the errors.
2. check under `log/` to check the latest lines of log any indication of error.

## Code and `git`

Code is under git: use it!

* You're free to do `git log/diff` as much as you want.
* Before a `git commit`, ensure to update `VERSION` and `CHANGELOG.md` when doing some change, so its nicely logged. Add emoji to make it fun!
* Before a `git push`, ensure that:
  * 1. the TESTS pass, and then
  * 2. docker container compiles (`just docker-build`).
* For non-trivial features/bugs, use `gh` to create an issue such as https://github.com/palladius/rails8-turbo-chat/issues/4.
  * Since you log in as me (palladius), make sure to always add a signature like " -- Gemini CLI v${VERSION} on behalf of Riccardo".

## Ruby

* we use `rbenv`, NOT `rvm`.
* if you get assets error (eg a missing image), try `rake assets precompile`.

## Dev Mode

I run this in local Linux ('derek') /Mac ('ricc-macbookpro3'). Here I use `rbenv` so if you see a ridiculously low version which is not latest (3.3.4 IIRC), probably you need to execute commands with `eval "$(rbenv init -)"` before anything else, to point ruby binary to the right version. Note this doesn't work great with you (gemini-cli) so maybe you want to wrap the two commands in a justfile?

## TODOs

Read `TODOs.md` in more details
