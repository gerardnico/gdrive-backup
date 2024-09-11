FROM restic/restic:0.17.1

####################################
# Label
# https://docs.docker.com/reference/dockerfile/#label
# This labels are used by Github
####################################
# * connect the repo
LABEL org.opencontainers.image.source="https://github.com/gerardnico/gdrive-backup"
# * set a description
LABEL org.opencontainers.image.description="Google Drive Backup"

###################################
# Packages
###################################
RUN apk update \
    # Bash is not installed with the busy box restic base image \
    && apk add --no-cache bash \
    # Curl
    && apk add --no-cache curl \
    # Fuse to mount drive
    && apk add --no-cache fuse3

###################################
# Rclone
###################################
COPY --chmod=0755 --from=rclone/rclone:1.67.0 /usr/local/bin/rclone /usr/local/bin

####################################
# Local User Configuration
####################################
# Create a host user `1000` called `me` for convenience when using WSL
# ie the UID 1000 is assigned to first non-root user
# Why? The user id created on Linux systems starts from 1000
# It permits to mount ssh keys and other asset in the home directory from a desktop
RUN addgroup -g 1000 megroup && \
    adduser -u 1000 -G megroup -D --shell /bin/bash me

####################################
# Gdrive Backup Script Installation
####################################
COPY --chmod=0755 gdrive-backup /usr/local/bin

####################################
# Rclone (Conf and Drive Path mount)
####################################
# Default GDRIVE remote rclone conf
ENV RCLONE_CONFIG_GDRIVE_TYPE=drive
ENV RCLONE_CONFIG_GDRIVE_SCOPE=drive.readonly,drive.metadata.readonly
# Disk path mount where gdrive is mounted by rclone
ENV GDRIVE_MOUNT_PATH="/gdrive"
RUN mkdir "$GDRIVE_MOUNT_PATH" && chmod 777 "$GDRIVE_MOUNT_PATH"

####################################
# Default ENTRYPOINT and CMD
####################################
ENTRYPOINT [""]
CMD ["gdrive-backup"]

