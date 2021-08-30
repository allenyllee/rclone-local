# rclone-local

## How to use

Run

```
eval "echo \"$(cat .env.template)\"" > .env
```

to generate a .env file which will be used in the docker-compose yml file.

Run

```
cp -n rclone/config/rclone.conf.template rclone/config/rclone.conf
```

with `-n` to not overwrite existing rclone.conf

and then run

```
docker-compose up -d
```
It'll start the container.
