## Prerequisites:

* Call `date +%Y%m%d-%H%M%S` to get YYYYMMDD-HHMMSS, you'll need it later.
* call `cat VERSION` or `cat app/VERSION` to get latest app version.

**IMPORTANT** Note this is a non-interactive chat. Do what you can, do NOT ask questions since nobody will answer. You're on your own.

## [DEV] Create a chat

We want to test App functionality via MCP Playwright.

* Navigate to http://localhost:8080/chats/ - allow for a 10sec timeout then exit with error
* Select the latest chat. either it has an image or not.
* **Step 1. If there is an image** (optional)
  * take a screenshot of the image
  * click "delete image"
  * Observe the image being deleted. Move to case 2 (yes, execute case 2 too)
* **Step 2. If there is NOT an image** (mandatory)
  * Ensure there is no image or exit with error.
  * Ensure there is some chat. If the chat is empty, ask a random questions on "image generation with LLMs" on it.
  * Wait 5 seconds for a reply.
  * Ensure the reply is populated.
  * Click on the "Generate image" button
  * Wait 10 seconds for the image to be generated.
  * Observe if its auto-refreshed with the image. If not, this should be a WARNING, not an error.
  * Take a screenshot of "screenshot-chat-$(ID)-image-step-2.png".
  * Reload the page and observe the image.
  * If no image, please exit with error "first image generation".
  * If all good, lets proceed to "Step 3"
* **Step 3. Image regeneration** (mandatory)
  * Ensure an image is there
  * click "regenerate image"
  * Wait 10 seconds for the image to be regenerated.
  * observe if autorefresh happens, if not reload.
  * Take a screenshot of the image: "screenshot-chat-$(ID)-image-step-3.png".
  * observe a NEW, DIFFERENT image. If its the same, log error that regeneration doesnt work.

## Image properties

* An image should be a cartoon, not a photo or realistic - add WARNING if so.
* The image should contain a ruby gem on the bottom right and a yellow heart emoji on the bottom left. While allowing
  some flexibility, if you don't find the ruby on bottom right you should throw an ERROR, since it's the
  image "signature". Throw a WARNING for the heart emoji if something is wrong there.

## Write your findings

Your findings should highlight functionality for this.

Execute:

* `mkdir test/ui-tests/02-ensure-chat-imagegen-functional`
* `touch test/ui-tests/02-ensure-chat-imagegen-functional/.keep`

### If everything is correct

* write a `test/ui-tests/02-ensure-chat-imagegen-functional/OK-${YYYYMMDD-HHMMSS}-dev-OK.json`
* This should contain a JSON with
  * "ret" (INTEGER): Should be 0
  * "chat_id" (INTEGER): Chat Id used for the test (null if unavailable)
  * "app_version" (STRING): app version
  * "message (STRING): Here you add something about your overall experience, like "everything worked fine".
  * "log" (STRING): Add a log of all the stdout conversation you -as Gemini CLI - have had with user.

### If something went wrong

If something went wrong with your experience, could be latency, or an image poorly positioned, or some debug text wrongly set on screen, ..
please write it down.

* write a `test/ui-tests/02-ensure-chat-imagegen-functional/${YYYYMMDD-HHMMSS}-dev-ERR.json`
* This should contain a JSON with
  * "ret" (INTEGER): "1"
  * "chat_id" (INTEGER): Chat Id used for the test (null if unavailable)
  * "app_version" (STRING): app version
  * "error_topic" (STRING): This should be where the error was found, could be "latency" "functionality" "UX" ...
  * "detailed_error" (STRING): This should describe where the error was found
  * "repro" (ARRAY): If you believe a human can reproduce this error, please add an array of bullet points which a user could reproduce, something like:
    [ "Navigate to URL..", "click button ...", "observe the page lags indefinitely", "and the image doesnt appear as intended"]
  * "log" (STRING): Add a log of all the stdout conversation you -as Gemini CLI - have had with user.
  * "md5_image_before" (STRING): an MD5 sum of the image before deletion/regeneration.
  * "md5_image_after" (STRING): an MD5 sum of the image after deletion/regeneration. This is needed to check the delete/create and "Regenerate" test.
    * Note: if more than 2 are created, use "md5_image_1", "md5_image_2", .. instead.


## [PROD] Now repeat everything in prod

Now repeat everything so far, but use:

* This url instead of localhost: https://rails8-turbo-chat-dev-272932496670.europe-west10.run.app/
* write files with PROD instead of DEV:
  * write a `test/ui-tests/02-ensure-chat-imagegen-functional/${YYYYMMDD-HHMMSS}-prod-OK.json`
  * write a `test/ui-tests/02-ensure-chat-imagegen-functional/${YYYYMMDD-HHMMSS}-prod-ERR.json`

## FINAL Actions

* If everything is right, no problem.
* If you found an error, please file a `gh` issue with https://github.com/palladius/rails8-turbo-chat/ . Bug should contain/start with "[02-chat-image-generation]".
* If you found an error, please also file a PR to https://github.com/palladius/rails8-turbo-chat/pulls with the files you've add/changed so far.
  * It should contain the new JSOn file and a few screenshots. These can help with investigation.
  * Link PR to issue and viceversa.
  * If the change is trivial to fix this error you've found, please propose a change and add to the PR.
  * Otherwise, just add your ideas in the PR text and just let the JSON speak, a human will follow up.

Thanks for your help!
