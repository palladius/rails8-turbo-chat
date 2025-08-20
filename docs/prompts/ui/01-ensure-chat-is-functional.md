## Prerequisites:

* Call `date +%Y%m%d-%H%M%S` to get YYYYMMDD-HHMMSS, you'll need it later.
* call `cat VERSION` or `cat app/VERSION` to get latest app version.

**IMPORTANT** Note this is a non-interactive chat. Do what you can, do NOT ask questions since nobody will answer. You're on your own.

## Create a chat in DEV

We want to test App functionality via MCP Playwright.

* Navigate to http://localhost:8080/chats/ - allow for a 10sec timeout then exit with error
* Click Start New chat
* Create a random question regarding Italy which the LLM can respond.
* wait 5 seconds for the LLM to respond.
* Create a followup question to the LLM response and click the "SEND" button.
* Wait 5 seconds for the LLM to respond.

## Write your findings

Your findings should highlight functionality for this.

Execute:

* `mkdir test/ui-tests/01-ensure-chat-functional`
* `touch test/ui-tests/01-ensure-chat-functional/.keep`

### If everything is correct

* write a `test/ui-tests/01-ensure-chat-functional/${YYYYMMDD-HHMMSS}-dev-OK.json`
* This should contain a JSON with
  * "ret" (INTEGER): Should be 0
  * "app_version" (STRING): app version
  * "chat_id" (INTEGER): Chat Id used for the test (null if unavailable)
  * "message (STRING): Here you add something about your overall experience, like "everything worked fine".

### If something went wrong

If something went wrong with your experience, could be latency, or an image poorly positioned, or some debug text wrongly set on screen, ..
please write it down.

* write a `test/ui-tests/01-ensure-chat-functional/${YYYYMMDD-HHMMSS}-dev-ERR.json`
* This should contain a JSON with
  * "ret" (INTEGER): "1"
  * "app_version" (STRING): app version
  * "chat_id" (INTEGER): Chat Id used for the test (null if unavailable)
  * "error_topic" (STRING): This should be where the error was found, could be "latency" "functionality" "UX" ...
  * "detailed_error" (STRING): This should describe where the error was found
  * "repro" (ARRAY): If you believe a human can reproduce this error, please add an array of bullet points which a user could reproduce, something like:
    [ "Navigate to URL..", "click button ...", "observe the page lags indefinitely", "and the image doesnt appear as intended"]


## Now repeat everything in prod

Now repeat everything so far, but use:

* This url instead of localhost: https://rails8-turbo-chat-dev-272932496670.europe-west10.run.app/
* write files with PROD instead of DEV:
  * write a `test/ui-tests/01-ensure-chat-functional/${YYYYMMDD-HHMMSS}-prod-OK.json`
  * write a `test/ui-tests/01-ensure-chat-functional/${YYYYMMDD-HHMMSS}-prod-ERR.json`


## FINAL Actions

* If everything is right, no problem.
* If you found an error, please file a `gh` issue with https://github.com/palladius/rails8-turbo-chat/ . Bug should contain/start with "[01-chat]".
* If you found an error, please also file a PR to https://github.com/palladius/rails8-turbo-chat/pulls with the files you've add/changed so far.
  * It should contain the new JSOn file and a few screenshots. These can help with investigation.
  * Link PR to issue and viceversa.
  * If the change is trivial to fix this error you've found, please propose a change and add to the PR.
  * Otherwise, just add your ideas in the PR text and just let the JSON speak, a human will follow up.

Thanks for your help!
