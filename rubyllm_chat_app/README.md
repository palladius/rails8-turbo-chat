
# Rails8 Turbo Chat

A simple chat application built with Rails 8 and Turbo.

## riccardo flow

```bash
. .env
# sets DB config locally to DEV
export DATABASE_URL="$DATABASE_URL_DEV"
# now bin/dev and rails c both work!
```

## Cloud Scheduler

to call a job from cloud schedulr, do this:

1. on app side,

   gcloud run services update [YOUR_SERVICE_NAME] \
     --set-env-vars CLOUD_SCHEDULER_SECRET=abc123 \
     --region [YOUR_REGION]

2. on CS side:


3. Local test:

```

bin/cloud-scheduler-local-test.sh
```
