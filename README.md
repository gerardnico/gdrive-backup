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


### Restic Repository Init

Before making a backup, you need to [initialize a Restic repository](https://restic.readthedocs.io/en/latest/030_preparing_a_new_repo.html) (where the backup snapshots are stored)

Example of a Restic Configuration for a [S3-compatible Storage](https://restic.readthedocs.io/en/latest/030_preparing_a_new_repo.html#s3-compatible-storage)
```bash
RESTIC_PASSWORD=your-restic-password 
RESTIC_REPOSITORY=s3:https://h0k0.ca.idrivee2-22.com/bucket_name/path_if_any
RESTIC_AWS_ACCESS_KEY_ID=the-access-key
RESTIC_AWS_SECRET_ACCESS_KEY=the-secret
```

You can then create it by executing the `restic init` command with this Docker run command
```bash
docker run \
  --rm \
  -it \
  -e RESTIC_PASSWORD=$RESTIC_PASSWORD \
  -e RESTIC_REPOSITORY=$RESTIC_REPOSITORY \
  -e AWS_ACCESS_KEY_ID=$RESTIC_AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$RESTIC_AWS_SECRET_ACCESS_KEY\
  ghcr.io/gerardnico/gdrive-backup:latest \
  restic init
```


### Rclone Configuration

When running with Docker the Rclone configuration is passed via [the rclone environment variables](https://rclone.org/docs/#environment-variables).
where the remote is `gdrive` and the environment follow then this syntax:  `RCLONE_CONFIG_REMOTE_NAME_XXX` 

You need to set the below configuration
```bash
RCLONE_CONFIG_GDRIVE_CLIENT_ID=your-gdrive-client-id
RCLONE_CONFIG_GDRIVE_CLIENT_SECRET=your-gdrive-client-secret
RCLONE_CONFIG_GDRIVE_TOKEN=your-gdrive-token
```

Note: The below configuration are optional because they are already set for you.
```bash
RCLONE_CONFIG_GDRIVE_TYPE=drive
RCLONE_CONFIG_GDRIVE_SCOPE=drive.readonly,drive.metadata.readonly
```

### Backup With Docker

In the Docker command: 
  * we pass the configuration via environment variables:
    * the [Rclone configuration](#rclone-configuration)
    * the [Restic configuration](#restic-repository-init)
  * we allow a Rclone mount with the following arguments
```bash
--cap-add SYS_ADMIN \
--device /dev/fuse
```


To make a dry-run on a back-up of the whole Google Drive, you would run this command:
```bash
docker run \
  --rm \
  --name gdrive-backup \
  -e RCLONE_CONFIG_GDRIVE_CLIENT_ID=$RCLONE_CONFIG_GDRIVE_CLIENT_ID \
  -e RCLONE_CONFIG_GDRIVE_CLIENT_SECRET=$RCLONE_CONFIG_GDRIVE_CLIENT_SECRET \
  -e RCLONE_CONFIG_GDRIVE_TOKEN=$RCLONE_CONFIG_GDRIVE_TOKEN \
  -e RESTIC_PASSWORD=$RESTIC_PASSWORD \
  -e RESTIC_REPOSITORY=$RESTIC_REPOSITORY \
  -e AWS_ACCESS_KEY_ID=$RESTIC_AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$RESTIC_AWS_SECRET_ACCESS_KEY \ 
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  ghcr.io/gerardnico/gdrive-backup:latest \
  gdrive-backup --dry-run /
```

If you want to execute it, just delete the `--dry-run` dry run option.


## Support

### Can I use a Service Account?

If you want to back up a personal account, you can't.

Why? 

Because service account are just regular user:
  * with an email 
  * without any right.
You need to give them the permission to read your disk via `Disk Sharing` and this feature
is only a Google Suite/Workspace feature.
