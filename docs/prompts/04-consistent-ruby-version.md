Ensure these 3 ruby versions are consistent and the same:

1. `app/.ruby-version` content, eg "1.2.3"
2. `app/Gemfile`. Ruby version, if any, should be the same as above. If missing, we're good, since bundler gets it from (1).
3. `app/Dockerfile`. Ensure ruby version image is the same.

## Corrective action

If this is NOT the case

1. please amend local code in (2)/(3) to coincide with (1).
2. Open an issue "[o4-ruby-version] v1 <> v2" where you put the 2 discrepant versions
3. Put in the issue where the problem is.
4. Possibly file a PR mentioning this issue and ficing it.
