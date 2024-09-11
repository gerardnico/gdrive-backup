# How to dev?



```bash
docker run \
  --rm \
  --name gdrive-backup \
  --user 1000:1000 \
  -it \
  -v $PWD/gdrive-backup:/opt/gdrive-backup/gdrive-backup \
  -e RCLONE_CONFIG_GDRIVE_CLIENT_ID=$RCLONE_CONFIG_GDRIVE_CLIENT_ID \
  -e RCLONE_CONFIG_GDRIVE_CLIENT_SECRET=$RCLONE_CONFIG_GDRIVE_CLIENT_SECRET \
  -e RCLONE_CONFIG_GDRIVE_TOKEN=$RCLONE_CONFIG_GDRIVE_TOKEN \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  ghcr.io/gerardnico/gdrive-backup:latest \
  bash
```