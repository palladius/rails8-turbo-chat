## Create a chat in DEV

We want to test App functionality via MCP Playwright.

* Navigate to http://localhost:8080/chats/
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
  * "chat_id" (INTEGER): Chat Id used for the test
  * "message (STRING): Here you add something about your overall experience, like "everything worked fine".

### If something went wrong

If something went wrong with your experience, could be latency, or an image poorly positioned, or some debug text wrongly set on screen, ..
please write it down.

* write a `test/ui-tests/01-ensure-chat-functional/${YYYYMMDD-HHMMSS}-dev-ERR.json`
* This should contain a JSON with
  * "ret" (INTEGER): "1"
  * "chat_id" (INTEGER): Chat Id used for the test
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
