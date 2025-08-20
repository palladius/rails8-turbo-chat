## v0.4.0 - on 20250820

*   feat: Add chat image generation via Gemini.
*   feat: Add a `just` command to populate a sample image for a chat.
*   refactor: Slim down the `just` command by moving the logic to a `Chat` model method.

## v0.3.18 - on 20250819

* Switched `ruby_llm` gem from git to a stable version from RubyGems.
* Updated `Gemfile.lock` to reflect the change.

## v0.3.17 - on 20250704

* Updating models and versions on Mac

* ## v0.3.16 - on 20250616

* UI: Footer is not sticky anymore.

## v0.3.15 - on 20250616

* Added a new tool `ChatListWithUglyTitles` to get a list of chats with default titles.
* Added `ugly_title?` method to the `Chat` model.
* Added `mcp-inspector` alias to `justfile`.

## v0.3.14 - on 20250616

* Added `DATABASE_URL` to `/config` page, with password and IP obfuscation.

## v0.3.13 - on 20250527

* Added `doc/er_diagram.md` explaining the database models and including a Mermaid ER diagram.

## CHANGELOG

## v0.3.12 - on 20250521

* Added commit hash and more vars to metadata.
* (b) adding 2 cloud-run only ENVs.

## v0.3.11 - on 20250521

* Improved styling and layout of the /config page for better readability of app metadata.
* Added MCP links to `app_metadata()`.

## v0.3.10 - on 20250520

* footer on bottom of page.
* Added `<% console %>` in dev.
* add a tool: `AppMetadata` super cool

## v0.3.9 - on 20250520

* reverting the ALLOWED_ORIGINS part

Error: ERROR: (gcloud.beta.run.deploy) argument --set-env-vars: Bad syntax for dict arg: [2a00:79e0:2846:6:7dec:ea52:c63a:50f9]. Please see `gcloud topic flags-file` or `gcloud topic escaping` for information on providing list or dictionary flag values with special characters.

* and now MCP finally works ! Yay! https://rails8-turbo-chat-dev-272932496670.europe-west10.run.app/mcp/sse

## v0.3.8 - on 20250520

* Added favicon.
* changing Procfile to not need the Facebook File Watcher since i cant install on derek.
* (B) trying Cloud Run in origin (who knows maybe its on th other side?!?)
* (c) better config
* (d) ricc mobile

## v0.3.7

* Added a '/config' page.
* (a) adding some ENV to cloud build for dev..
* (b) adding to also deploy script or wont be used

## v0.3.6

* ALLOW HOSTS refactoring, maybe its better now.
* also removed auth for /mcp/ paths..

## v0.3.5

* added silly yet convenient MCP link on top

## v0.3.4

* Fixing the remote IPs and trying again to allow Derek to connect to MCP remote server..
    * Next step would be to parse an array of IPs from ENV to make this viable.
* Ok now it fails differently:
    *  `{"jsonrpc":"2.0","error":{"code":-32600,"message":"Forbidden: Origin validation failed"},"id":null}`

## v0.3.3

* Adding Riccardo Zurich server to allowed hosts to test MCP from `MCP Inspector v0.12.0`. I know, should be parsed from `ENV`...
* Added chat title auto-refinement. Works like a charm!
* Fixing the Gemini API Key in `User.all.to_json` thanks to this:
    * `Devise::Models::Authenticatable::BLACKLIST_FOR_SERIALIZATION << :gemini_api_key`

## v0.3.2

* Adding useful functionalties.
* `list_user.rb` / `create_user` allows to list/create users. Creation failed due to missing (mandatory) password in input.
* `chat_list.rb` gives a list of chats. This is coming so well from my python client!

## v0.3.1

* adding `fast_mcp` MCP support as per https://learnitnow.medium.com/bridging-the-gap-connecting-python-ai-agents-to-ruby-apps-with-mcp-614977012399

## v0.3.0

*   Added support for Gemini API key per user, including database migration, permitting the parameter in Devise, and displaying a key emoji in the header if a valid key is present.
*   Note API isnt used anywhere yet. We're just configuring the DB for BYO Gemini Key.

## v0.2.8

*   fixing productions, disabling some HTTPS requirements... the usual.

## v0.2.7

*   cleaner header.

## v0.2.6

*   Implemented background job (`AutotitleChatsJob`) and secure endpoint (`/jobs/autotitle_chats`) for scheduled chat auto-titling via Cloud Scheduler.
*   Implemented background job (`AutotitleChatsJob`) for chat auto-titling.
*   Created a secure endpoint (`/jobs/autotitle_chats`) in `JobsController` to trigger the job, protected by a shared secret.
*   Added a GET route for `/jobs/autotitle_chats` for local testing.
*   Skipped CSRF verification for `JobsController`.
*   Skipped Devise authentication for `JobsController`.
*   Removed Sorbet annotations from `JobsController` and `AutotitleChatsJob` to resolve local testing issues.
*   This change required setting a `CLOUD_SCHEDULER_SECRET` environment variable.
* added `.env.dist`

## v0.2.5

*   Removed "You" and "Bot" labels from messages, using emojis instead.
*   Updated mobile chat sidebar to hide the current chat when the sidebar is open.
*   Improved user name/email display in header: bold, title-cased, and prepended with a human emoji.
*   Made the main header title a link to the home page.
*   Added a separate "Home" link to the header.
*   Abbreviated environment indicator in header to "(dev)" or "(prod)".

## v0.2.4 (UI)

* Added environment indicator (DEV/PROD/TEST) to the footer.

## v0.2.3 (UX)

* Now chat also autoscrolls!

## v0.2.2 (UX)

* chat TextArea has now ENTER -> send message.
* chat TextArea has now SHIFT ENTER -> continue adding stuff to message.
* => I start loving javascript, when someone else writes it for me!

**Note** this was committed as 0.2.1 -> gemini-code was editing for me so i did a rogue git commit before updating V/C. So this msg is committed wihth 0.2.2/0.2.3 altogether.

## v0.2.1  (UI/UX)

* on small screens (eg, mobile), folds the left chat.

## v0.2.0

* app is SO GOOD I'm gonna promote it to 0.2.0 and create a tag for it.

## v0.1.15

* Added a footer partial with app version, links to GitHub and Cloud Run environments (Dev/Prod), and a "Made with love" attribution.

## v0.1.14

* Further UI refinements for dark theme, including message bubble colors, bold text, and code block styling.
* Added an About page with a link in the header and included the Gemini-inspired image and GitHub repo link.

## v0.1.13

* Refactored UI to a dark theme with a Gemini-inspired gradient.

##  v0.1.12

* adding version to header
* CLOUD_RUN_ENDPOINT (dev) to cloud build, so Im feeding it to dev/prod.
* when it works for dev, i'll do the work also for prod.

##  v0.1.11

* adding `CLOUD_RUN_ENDPOINT` env support

## v0.1.10

feat: Add CRun dev to known hosts.

```ruby
config.hosts << "rails8-turbo-chat-dev-272932496670.europe-west10.run.app"
```


## v0.1.9

feat: Add application header

- Displays "Rails8 Turbo Chat 💬" in a new site-wide header.
- Updates changelog and version.

## v0.1.8 and before

```bash
2025-05-13 v0.1.8 exposing port 8080 explicitly in Dockerfile.
2025-05-12 v0.1.7 Finally fixed CloudBuild! It builds the repo on AR for now. No pushing on CRun yet.
2025-05-11 v0.1.6 lots of small Ops tests
2025-05-11 v0.1.5 markdown WORKS!!!
2025-05-11 v0.1.4 autonaming of chat titles.
2025-05-11 v0.1.3 added chat edit
2025-05-11 v0.1.2 For some reason i do NOT understand it works. I was playing with https://rubyllm.com/guides/rails > Persisting Instructions and I created a chat record with instructions. After this, also Chat object started working. Weird.
2025-05-11 v0.1.1 Added Carmine fix to Gemfile with empty msg from Gemini.
2025-04-22 v0.1.0 Had gemini bug.
2025-04-19 v????? Initial stesure.
```