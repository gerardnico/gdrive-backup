# How to dev?



Note of warning: 
The command below adds the path `/gdrive` to the `RESTIC_REPOSITORY`
because I use one bucket to host all restic repository.
You may want to delete it to match your environment.


This command mount the [gdrive-backup](../gdrive-backup) script
and start bash, making it easy to change it and execute it.


```bash
docker run \
  --rm \
  --name gdrive-backup \
  --user 1000:1000 \
  -it \
  -v $PWD/gdrive-backup:/usr/local/bin/gdrive-backup \
  -e RCLONE_CONFIG_GDRIVE_CLIENT_ID=$RCLONE_CONFIG_GDRIVE_CLIENT_ID \
  -e RCLONE_CONFIG_GDRIVE_CLIENT_SECRET=$RCLONE_CONFIG_GDRIVE_CLIENT_SECRET \
  -e RCLONE_CONFIG_GDRIVE_TOKEN=$RCLONE_CONFIG_GDRIVE_TOKEN \
  -e RESTIC_PASSWORD=$RESTIC_PASSWORD \
  -e RESTIC_REPOSITORY=$RESTIC_REPOSITORY/gdrive \
  -e AWS_ACCESS_KEY_ID=$RESTIC_AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$RESTIC_AWS_SECRET_ACCESS_KEY \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  ghcr.io/gerardnico/gdrive-backup:latest \
  gdrive-backup -n /
  bash
```

