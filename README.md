# Google Drive Backup



## About

A Google Drive script and Docker container to back up Google Drive with the help of:
* restic
* and rclone



## Run

### Docker

```bash
docker run \
  --rm \
  --name gdrive-backup \
  ghcr.io/gerardnico/dokuwiki:latest
```