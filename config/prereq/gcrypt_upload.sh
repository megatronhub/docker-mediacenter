#!/bin/bash
# RClone Config file
RCLONE_CONFIG=/data/rclone/rclone.conf
export RCLONE_CONFIG

#exit if running
if [[ "`pidof -x $(basename $0) -o %PPID`" ]]; then exit; fi

# Move older local files to the cloud
/usr/bin/rclone move /data/local_media/ gcrypt: \
--log-file /data/rclone/logs/upload.$(date +%F_%R).log \
-v \
--exclude-from /data/rclone/scripts/excludes \
--delete-empty-src-dirs \
--user-agent 478201604 \
--fast-list \
--max-transfer 700G