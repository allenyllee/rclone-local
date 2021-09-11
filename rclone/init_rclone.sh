#!/usr/bin/env sh
# echo $@

trap kill_pid SIGINT
trap kill_pid SIGTERM
trap kill_pid SIGKILL

function kill_pid() {
    kill $pid1
    sleep 1
}

function cleanup() {
    echo "** cleanup"
    umount /data/gDrive
    fusermount -u /data/gDrive
    umount -l /data/gDrive
    umount /data/pDrive
    fusermount -u /data/pDrive
    umount -l /data/pDrive
}

echo "starting..."
cleanup

mkdir -p /data/gDrive
mkdir -p /data/pDrive

/usr/local/bin/rclone \
        `# -------- rc options ---------` \
        --rc \
        --rc-serve \
        --rc-addr localhost:5573 \
        --rc-no-auth \
        `# -------- global options ---------` \
        --contimeout 3m \
        --timeout 5m \
        --transfers 4 \
        --check-first \
        --checkers 8 \
        --order-by size,mixed,75 \
        --max-depth -1 \
        --checksum \
        --exclude-from /rclone/config/exclude-list.txt \
        --delete-excluded \
        --buffer-size 64M \
        --use-mmap \
        --log-level INFO \
        --log-file /dev/stdout \
        --bwlimit "09:00,512k:off 23:00,off:off" \
        --bwlimit-file off:off \
        --tpslimit 4 \
        --tpslimit-burst 8 \
        --track-renames \
        --fast-list \
        --config /config/rclone/rclone.conf \
        `# ------- mount options ---------` \
        mount gCache: /data/gDrive \
        --allow-other \
        --allow-non-empty \
        --daemon-timeout 10m \
        --attr-timeout 1m \
        `## ------- vfs options ---------` \
        --cache-dir /rclone/cache \
        --vfs-cache-mode writes \
        --vfs-cache-max-age 336h \
        --vfs-write-back 1m \
        --vfs-read-chunk-size 32M \
        --vfs-read-chunk-size-limit 512M \
        `# -------- file permission options ---------` \
        --uid 1000 \
        --gid 1000 \
        --dir-perms 0777 \
        --file-perms 0777 \
        --umask 0000 \
        &

pid1=$!

# must sleep for a while to ensure rc serve is running
sleep 1

/usr/local/bin/rclone rc \
    --rc-addr localhost:5573 \
    --rc-no-auth \
    mount/mount \
    fs=pCache: \
    mountPoint=/data/pDrive \
    mountType=mount

# Wait utile all subprocess stopped
wait

#Cleanup
cleanup

# run passed argument as command
$@
