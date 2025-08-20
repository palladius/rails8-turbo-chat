## Prerequisites:

* Call `date +%Y%m%d-%H%M%S` to get YYYYMMDD-HHMMSS, you'll need it later.
* call `cat VERSION` or `cat app/VERSION` to get latest app version.

# Check that we are at latest version

After a `git commit` and `git push`, and after 5-6 miuntes, we should observe that the VERSION in the footer of all
pages converges to the same.

Use MCP + Playwright for this (or just curls).

##  Check version discrepancy

1. navigate to https://localhost:8080/ and check footer, extract local version
2. compare with `app/VERSION`. Should be the same
3. Check with DEV and PROD apps:
   1. https://rails8-turbo-chat-dev-272932496670.europe-west10.run.app/
   2. https://rails8-turbo-chat-prod-272932496670.europe-west10.run.app/

You should now have 4 versions. If they're all the same, all good.

If localhost / VERSION differ, a restart of `just dev` should do.

## What if dev/prod versions differ?

Well now, maybe, the Cloud Builds are broken!

1. Check `just cloud-build-list` for a list of existing builds and broken ones.
2. Check `just cloud-build-show-log BUILD_ID` with the failed build from previous command.
3. Check this `BUILD_ID` in existing open GH issues (see below).

## Investigate the builds

* Check Cloud Build failed timestamps. When was the last time it worked, when was the first time if failed? Likely we have a breaking change we can observe with a git diff.
* If you are able to get the `git commit` hash from the log, GOOD. If not, you can just check the timestamps. For instance,
  * if the latest GOOD was at 13:02 of today
  * if the first BAD was at 14:51 of today
  * Check `git log` any commit done around those times.
  * Check UTC/current TZ. Developer is in "Europe/Zurich", so check a +1h discrepancy possibly.

If you find broken builds, please

1. Create an issue with title of this template: "[03-broken-build] BUILD_ID DESCRIPTION_OF_ISSUE", adding as much info as you have.
2. Try to scrape out local disk/computer/environment information if ran from localhost, but preserve Cloud Build logs (which are run in the cloud).

## Output

Write your output under `rubyllm_chat_app/test/ui-tests/03-cloud-build-functional/`

* Create a file called "YYYYMMDD-HHMMSS-OK.json" if everything went ok. Use the date from above.
* Create a file called "YYYYMMDD-HHMMSS-ERR.json" if there was an error. Use the date from above.
* Write the version discrepancy in those JSON ("local_version" , "dev_version", "prod_version")
* Write the "cloud-build" error, if any. the last 2-3 lines of the error before it exited are usually quite enlightning.
* Write your "investigation" as why it failed, if you can, in the JSON.
* Add "github_issue_url", if any.
