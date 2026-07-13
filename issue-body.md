## Image generation is broken on dev and prod environments

### Description
Image generation on dev and prod environments seems to be broken. After clicking 'Generate Image', the image is not displayed correctly.

### Steps to reproduce
1. Navigate to https://rails8-turbo-chat-dev-272932496670.europe-west10.run.app/ or https://rails8-turbo-chat-prod-272932496670.europe-west10.run.app/
2. Log in with playwright credentials
3. Go to chats
4. Select the latest chat
5. Click on 'Generate Image'
6. Observe the broken image

### Environment
- Dev: https://rails8-turbo-chat-dev-272932496670.europe-west10.run.app/
- Prod: https://rails8-turbo-chat-prod-272932496670.europe-west10.run.app/

### Reports
- [dev error report](test/ui-tests/02-ensure-chat-imagegen-functional/20250822-103920-crundev-ERR.json)
- [prod error report](test/ui-tests/02-ensure-chat-imagegen-functional/20250822-103920-crunprod-ERR.json)

I have screenshots of the broken images locally.
