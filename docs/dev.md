# How to dev?



```bash
docker run \
  --rm \
  --name gdrive-backup \
  --user 1000:1000 \
  -it \
  -v $PWD/gdrive-backup:/opt/gdrive-backup/gdrive-backup \
  ghcr.io/gerardnico/dokuwiki:latest \
  bash
```