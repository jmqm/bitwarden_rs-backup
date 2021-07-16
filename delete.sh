#!/bin/sh

# Go to the backups directory.
cd /backups

# Find all tar.xz archives older than x days and store them in a variable.
TO_DELETE=$(find . -iname "*.tar.xz" -type f -mtime +$DELETE_AFTER)

if [ "$TO_DELETE" -gt 0 ]; then
    # Delete tar.xz archives older than x days.
    find . -iname "*.tar.xz" -type f -mtime +$DELETE_AFTER -exec rm -f {} \;

    # Echo that archives were deleted.
    echo "[$(date +"%F %r")] Deleted archives older than $DELETE_AFTER days."
else
    # Echo that there are no archives to delete.
    echo "[$(date +"%F %r")] No archives older than $DELET_AFTER days to delete."
fi
