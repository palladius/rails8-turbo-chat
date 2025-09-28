## v0.8.13 - on 20250928

*   feat(view): Removing message textarea for public chats you don't own.
*
## v0.8.12 - on 20250928

*   feat(ui): Add a warning if `GEMINI_API_KEY` is not set.
*   fix(helper): `display_secret_env_variable` now correctly handles non-JSON values, showing only the first 5 characters.

## v0.8.11 - on 20250824

*   feat(ui): Improved mobile chat experience by hiding the left pane on smaller screens.

## v0.8.10 - on 20250823

*   fix: Correctly define `publicize_chat_path` route (issue #37).

## v0.8.7 - on 20250823

* introduces  `publicize_chat_path` but forgets the route => **BROKEN**.

## v0.8.6 - on 20250823

*   fix: Add `null: false` constraint to `public` column in chats migration (issue #37).

## v0.8.5 - on 20250823

*   feat: Homepage UI improvements (split login/signup, remove show all for unauthenticated) (issue #37).

## v0.8.4 - on 20250823

*   fix: Allow unauthenticated access to homepage (ChatCardsController#index) (issue #37).

## v0.8.3 - on 20250823

*   feat: Add "Log In / Sign Up" button to homepage for logged-out users (issue #37).

## v0.8.2 - on 20250823

*   feat: Prepend eyes emoji to public chat titles in individual chat view (`_chat.html.erb`) (issue #37).

## v0.8.0 - on 20250823

*   feat: Complete implementation of `public` attribute for Chat model, including UI and homepage display (issue #37).
*   feat: Display public chats with eyes emoji and "Public" button in CARDS view (issue #37).

## v0.7.4 - on 20250823

*   feat: Add `public` attribute to Chat model and display public chats in CARDS view (issue #37).

## v0.7.3 - on 20250823

*   feat: Add checks for `GCLOUD_REGION` and `GEMINI_API_KEY` in config errors.

## v0.7.2 - on 20250823

*   feat: Add a visual warning for configuration errors (issue #36)

## v0.7.1 - on 20250821

🔵 ✨ Added a "Start New Chat" button to the homepage for easier access.

## v0.7.0 - on 20250821

🔵 ✨ Automatically trigger "I'm feeling lucky" experience when a chat becomes long enough.
🔵 ✨ Display a notice to the user when the "I'm feeling lucky" job is running.

## v0.6.0 - on 20250821

🔵 ✨ Added "Regenerate Title" button for chats with default titles.
🔵 ✨ Added "Generate Description" and "Regenerate Description" buttons.
🔵 ✨ Added "I'm feeling lucky" button to generate image, title, and description in one click.
🔵 🎨 Improved the UI of chat action buttons to be smaller and curvy.
🔵 ✨ Made chat images clickable to view the full-size version.
🔵 🐛 Buttons for generative actions are now hidden for chats with less than 2 messages.

## v0.5.13 - on 20250821

*   feat(ui): Make the entire chat card clickable.

## v0.5.12 - on 20250820

*   feat(ui): Add chat cards view at root path.
*   feat(ui): Filter chat cards by default to only show chats with images.
*   feat(ui): Add a button to show all chats.
*   fix(ui): Scope chat cards to the current user.
*   refactor(ui): Improve chat cards layout.
*   refactor(prompt): Update the prompt for image generation.

## v0.5.11 - on 20250820

* Removed `ENABLE_GCP` added twice by mistake

## v0.5.10 - on 20250820

*   ricc: Added `NO_COLOR` to stop having colorful rails logs inside Cloud Run logs. I love them locally, but not in Cloud Logs.
*   ricc: Removed `GCS_CREDENTIALS_JSON` from the very same script `app/bin/ricc-cb-push-to-cloudrun-magic.sh`

## v0.5.9 - on 20250820

*   feat(ui): Display GCS_BUCKET and GCS_CREDENTIALS_JSON on the /config page.

## v0.5.8 - on 20250820

*   fix(cloudbuild): Pass GCS_CREDENTIALS_JSON to Cloud Run.
*   feat(gcs): Add initializer to set GCS_BUCKET from PROJECT_ID.

## v0.5.7 - on 20250820

*   fix(gcs): Correctly configure GCS environment variables in the deployment script.
*   fix(gcs): Use `PROJECT_ID` instead of `GCS_PROJECT` in `storage.yml`.

## v0.5.5 - on 20250820

*   fix(ci): Temporarily disable passing the git commit message to Cloud Run to prevent build failures.

## v0.5.4 - on 20250820

*   fix(gcs): Conditionally load GCS credentials to support both local and Cloud Run environments.

## v0.5.2 - on 20250820

*   feat(ui): Add emojis to "Edit Chat", "Delete Chat", and "Generate Image" buttons.

## v0.5.1 - on 20250820

*   fix(docker): Pin the Docker base image to a specific digest to prevent build failures from upstream changes.
*   fix(docker): Correct the Ruby version in the Dockerfile to match the `.ruby-version` file.

## v0.5.0 - on 20250820

*   feat: Configure Active Storage to use Google Cloud Storage for image uploads.
*   feat: Add `iac/gcs_setup.sh` script to create and configure the GCS bucket and a service account.
*   feat: Add `just` commands and scripts for generating and deleting images.
*   fix: Correctly handle GCS credentials and YAML parsing in `config/storage.yml`.
*   fix: Ensure `rails runner` commands connect to the correct database.

## v0.4.3 - on 20250820

*   feat: Add `run_ui_tests.sh` to automate UI testing and log output.
*   refactor: Update `justfile` to use the new UI test script.

## v0.4.2 - on 20250820

*   feat: Implement working image generation with `imagen-3.0-generate-002`.
*   feat: Add `just` command to generate images for a specific chat.
*   feat: Add idempotency check to `GenerateChatImageJob`.
*   fix: Correctly handle image data from `ruby_llm` gem.
*   fix: Resolve `manpages` gem `LoadError`.

## v0.4.1 - on 20250820

*   fix(ui): Correctly align chat image to be 33% on the right and chat details to be 66% on the left.

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

Error: ERROR: (gcloud.beta.run.deploy) argument --set-env-vars: Bad syntax for dict arg: [2a00:79e0:2846:6:7dec:ea52:c6a:50f9]. Please see `gcloud topic flags-file` or `gcloud topic escaping` for information on providing list or dictionary flag values with special characters.

* and now MCP finally works ! Yay! https://rails8-turbo-chat-dev-2272932496670.europe-west10.run.app/mcp/sse

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
*   Added `.env.dist`

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
