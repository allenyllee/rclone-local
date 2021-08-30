#!/usr/bin/env bash
# echo $@

# sudo mkdir -p /gdrive/mount
# sudo mkdir -p /mnt/test/mount

MOUNTPOINT="/mnt/rclone"
MOUNTPOINT_CONFIG="$(pwd)/rclone"


# sudo umount $MOUNTPOINT/gdrive
# rm -r $MOUNTPOINT/gdrive
# mkdir -p $MOUNTPOINT/gdrive

docker run -ti -d \
    --name rclone-local \
    --restart=always \
    --log-opt max-size=10m \
    --log-opt max-file=10 \
    --volume $MOUNTPOINT_CONFIG:/rclone \
    --volume $MOUNTPOINT_CONFIG/config:/config/rclone \
    --volume $MOUNTPOINT:/data:shared \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \
    --device /dev/fuse --cap-add SYS_ADMIN --security-opt apparmor:unconfined \
    --entrypoint /rclone/init_rclone.sh \
    rclone/rclone
