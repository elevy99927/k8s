kubectl create cronjob my-job --image=busybox --schedule="*/1 * * * *" -- date
