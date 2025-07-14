Gemini, if you read this, make sure to report to the user a list of unactioned todos at the begignning of your conversation, so you can agree with user what they want to work on.

* _[ ] Test **MCP images**. Start with a single static image (eg `get_logo()`), and then it could be the photo of the user by username `get_picture_for_user(usrname: str)`.
* _[ ] Test **MCP auth**.Try authenticate with MCP authentication. Let's see if its compatible with Devise auth (user/pass). If yes, good. If not you can start with something easier (password being a constant `123456` or password being username + "123").
