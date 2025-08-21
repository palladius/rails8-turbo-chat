## Prerequisites:

* Call `date +%Y%m%d-%H%M%S` to get YYYYMMDD-HHMMSS, you'll need it later.
* call `cat VERSION` or `cat app/VERSION` to get latest app version.

**IMPORTANT** Note this is a non-interactive chat. Do what you can, do NOT ask questions since nobody will answer. You're on your own.

## Test chat form reset

We want to test the chat form reset functionality via MCP Playwright.

* Navigate to http://localhost:8080/chats/
* Click "Start New Chat".
* Wait for the new chat to be created and the page to load.
* In the textarea, type "Hello, this is a test message".
* Click the "Send 🚀" button.
* Wait for 2 seconds.
* Check the value of the textarea. It should be empty.
* If the textarea is empty, the test is successful.
* If the textarea is not empty, the test has failed.

## Write your findings

* Create a directory `test/ui-tests/04-ensure-chat-form-resets`
* If the test is successful, create a file `test/ui-tests/04-ensure-chat-form-resets/${YYYYMMDD-HHMMSS}-dev-OK.json` with `{"ret": 0}`.
* If the test fails, create a file `test/ui-tests/04-ensure-chat-form-resets/${YYYYMMDD-HHMMSS}-dev-ERR.json` with `{"ret": 1, "error": "Textarea not cleared after sending message"}`.
