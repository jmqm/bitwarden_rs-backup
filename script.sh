#!/bin/sh

# --------------- [ PREREQUISITES ] ---------------

EXTENSION="tar.xz"


# ------------------ [ BACKUP ] ------------------

cd /data || exit 1  # Exit with error if opening vw data file fails 
BACKUP_LOCATION="/backups/$(date +"%F_%H-%M-%S").${EXTENSION}"

BACKUP_DB="db.sqlite3" # file
BACKUP_RSA="rsa_key*" # files
BACKUP_CONFIG="config.json" # file
BACKUP_ATTACHMENTS="attachments" # directory
BACKUP_SENDS="sends" # directory

# Create list of backup items to archive
BACKUP_ITEMS="$BACKUP_DB $BACKUP_RSA $BACKUP_CONFIG $BACKUP_ATTACHMENTS $BACKUP_SENDS"

# Verify which items are available to be backed up
FILES_TO_BACKUP=""
WARNING=""

for ITEM in $BACKUP_ITEMS; do
    if [ -e "$ITEM" ] || [ -d "$ITEM" ]; then
        FILES_TO_BACKUP="$FILES_TO_BACKUP $ITEM"
    else # if an item is missing, raise warning
        WARNING="$WARNING $ITEM"
    fi
done

# Print the warnings out in the docker logs
if [ -n "$WARNING" ]; then
    echo "[WARNING] The following expected files/directories are missing:$WARNING" >&2
fi


# Back up files and folders, only if there are files to back up
if [ -n "$FILES_TO_BACKUP" ]; then
    echo "[INFO] Backing up:$FILES_TO_BACKUP"
    tar -Jcf "$BACKUP_LOCATION" $FILES_TO_BACKUP
    OUTPUT="New backup created"
else
    OUTPUT="No files to back up"
fi



# ------------------ [ DELETE ] ------------------

if [ -n "$DELETE_AFTER" ] && [ "$DELETE_AFTER" -gt 0 ]; then
    cd /backups

    # Find all archives older than x days, store them in a variable, delete them.
    TO_DELETE=$(find . -iname "*.${EXTENSION}" -type f -mtime +$DELETE_AFTER)
    find . -iname "*.${EXTENSION}" -type f -mtime +$DELETE_AFTER -exec rm -f {} \;

    OUTPUT="${OUTPUT}, $([ ! -z "$TO_DELETE" ] \
                       && echo "deleted $(echo "$TO_DELETE" | wc -l) archives older than ${DELETE_AFTER} days" \
                       || echo "no archives older than ${DELETE_AFTER} days to delete")"
fi


# ------------------ [ EXIT ] ------------------

echo "[$(date +"%F %r")] ${OUTPUT}."