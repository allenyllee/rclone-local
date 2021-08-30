#!/usr/bin/env bash
# echo $@

# sudo mkdir -p /gdrive/mount
# sudo mkdir -p /mnt/test/mount

MOUNTPOINT="/mnt/wsl/rclone"
MOUNTPOINT_CONFIG="/mnt/d/rclone"


# sudo umount $MOUNTPOINT/gdrive
# rm -r $MOUNTPOINT/gdrive
# mkdir -p $MOUNTPOINT/gdrive

docker run -ti \
    --name rclone-gdrive \
    --rm \
    --volume $MOUNTPOINT_CONFIG:/rclone \
    --volume $MOUNTPOINT_CONFIG/config:/config/rclone \
    --volume $MOUNTPOINT:/data:shared \
    --device /dev/fuse --cap-add SYS_ADMIN --security-opt apparmor:unconfined \
    --entrypoint /rclone/init_rclone.sh \
    rclone/rclone \
    "sh"
