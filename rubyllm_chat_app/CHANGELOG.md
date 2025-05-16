## CHANGELOG

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
