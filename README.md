# Google Drive Backup



## About

A Google Drive script and Docker container to back up Google Drive for personal account with the help of:
* restic
* and rclone



## Steps

### Get your Google Drive Client Id and Secret

To be able to talk to the Google Drive Api, you 
need to [get client id and secret ](https://rclone.org/drive/#making-your-own-client-id)

### Get your Google Drive Token

Once you get your client id and secret, you need [to run a rclone config to get a token](https://rclone.org/drive/#configuration)

The config should use:
* the name `gdrive`, 
* the client id and secret id of the previous step
* the type `17` (ie Google Drive)
* the scope `2` (read file and metadata)
* empty service account

Steps: 
* [Install rclone](https://rclone.org/install/) on your desktop. Note: we cannot use docker because a browser is needed to interact with Google when asking for an OAuth token.
* Create a `rclone.conf` in the current directory
```bash
rclone config --config ./rclone.conf
```
* Open the file `rclone.conf`, you should see your token
```ini
[gdrive]
type = drive
client_id = xxxxxx
client_secret = xxxxxxx
scope = drive.readonly,drive.metadata.readonly
token = {"access_token":"xxx","token_type":"Bearer","refresh_token":"xxxxxxxxxx","expiry":"2024-09-11T14:41:29.478706453+02:00"}
```


### Backup With Docker

When running with Docker:
* the Rclone configuration is passed via [rclone environments](#rclone-environments-variables)
* the Restic configuration is passed via restic environments

```bash
# Rclone
RCLONE_CONFIG_GDRIVE_CLIENT_ID=your-gdrive-client-id
RCLONE_CONFIG_GDRIVE_CLIENT_SECRET=your-gdrive-client-secret
RCLONE_CONFIG_GDRIVE_TOKEN=your-gdrive-token
```

Run
```bash
docker run \
  --rm \
  -e RCLONE_CONFIG_GDRIVE_CLIENT_ID=$RCLONE_CONFIG_GDRIVE_CLIENT_ID \
  -e RCLONE_CONFIG_GDRIVE_CLIENT_SECRET=$RCLONE_CONFIG_GDRIVE_CLIENT_SECRET \
  -e RCLONE_CONFIG_GDRIVE_TOKEN=$RCLONE_CONFIG_GDRIVE_TOKEN \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  --name gdrive-backup \
  ghcr.io/gerardnico/gdrive-backup:latest
```


## Support

### Rclone Environments Variables

In Docker, the rclone remote name is configured via [the native rclone environment variable](https://rclone.org/docs/#environment-variables).
ie `RCLONE_CONFIG_REMOTE_NAME_XXX` where the remote is named `gdrive`

The below configuration are optional because they are already set for you.
```bash
RCLONE_CONFIG_GDRIVE_TYPE=drive
RCLONE_CONFIG_GDRIVE_SCOPE=drive.readonly,drive.metadata.readonly
```

### Can I use a Service Account?

If you want to back up a personal account, you can't.

Why? 

Because service account are just regular user:
  * with an email 
  * without any right.
You need to give them the permission to read your disk via `Disk Sharing` and this feature
is only a Google Suite/Workspace feature.
