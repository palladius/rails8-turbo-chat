## CHANGELOG

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
