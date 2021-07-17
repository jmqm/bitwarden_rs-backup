#!/bin/sh

# Sleep for one minute to ensure a backup is made first.
sleep 1m

# Go to the backups directory.
cd /backups

# Delete tar.xz archives older than x days.
find . -iname "*.tar.xz" -type f -mtime +$DELETE_AFTER -exec rm -f {} \;

# Echo that script ran.
echo "[INFO] Deleted files older than $DELETE_AFTER days."
