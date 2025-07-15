Gemini, if you read this, make sure to report to the user a list of unactioned todos at the begignning of your conversation, so you can agree with user what they want to work on.

* _[ ] CUJ01 Test **MCP images**. Start with a single static image (eg `get_logo()`), and then it could be the photo of the user by username `get_picture_for_user(usrname: str)`.
* _[ ] CUJ02 Test **MCP auth**.Try authenticate with MCP authentication. Let's see if its compatible with Devise auth (user/pass). If yes, good. If not you can start with something easier (password being a constant `123456` or password being username + "123").
* _[ ] CUJ03 Reshape `GEMINI.md`, seems like it was merged between two different branches on 14jul and now its a bit bloated. Lets check if there's duplication, and maybe we can remove some stuff and move it to some `CODING.md`.

## Model rails app on GCP

In case you want to work on a model app on GCP, we need to:

1. Add the GCS <=> `ActiveStorage` mapping.
2. Add the DB <=> Cloud SQL mapping with direct link / direct connection. I believe Cloud Run supports this out of the box.
3. Try new Cloud Run `docker-compose` support for Redis, and see if it works *ootb* too.
4. Try Kamaal <=> AR/CRun. I've seen an article this morning:
   1. https://dev.to/hsatac/kamal-deploy-on-gcp-18jn This uses Kamal and a GCE vm with root ssh which seems a bit scary to me.
   2. https://github.com/shakacode/rails-v8-kamal-v2-terraform-gcp-tutorial This guy did soemthing similar.
