#!/bin/sh

BACKUP_CMD="/sbin/su-exec ${UID}:${GID} /app/backup.sh"
DELETE_CMD="/sbin/su-exec ${UID}:${GID} /app/delete.sh"
LOGS_FILE="/app/log/backup.log"

# If passed "manual", run backup script once ($1 = First argument passed).
if [ "$1" = "manual" ]; then
    echo "[INFO] Running one-time, started at $(date +"%F %r")."
    $BACKUP_CMD
    exit 0
fi

# Create cron jobs.
if [ "$(id -u)" -eq 0 ] && [ "$(grep -c "$BACKUP_CMD" "$CRONFILE")" -eq 0 ]; then
    # Add backup script to cron job list.
    echo "$CRON_TIME $BACKUP_CMD >> $LOGS_FILE 2>&1" | crontab -

    # Check if $DELETE_AFTER is not null and is greater than 0.
    # If so, add it to the cron job list.
    if [ -n "$DELETE_AFTER" ] && [[ "$DELETE_AFTER" -gt 0 ]]; then
        echo "$CRON_TIME $DELETE_CMD >> $LOGS_FILE 2>&1" | crontab -
    fi
fi

# Start crond if it's not running.
pgrep crond > /dev/null 2>&1
if [ $? -ne 0 ]; then
    /usr/sbin/crond -L /app/log/cron.log
fi

# Restart script as user "app:app".
if [ "$(id -u)" -eq 0 ]; then
    exec su-exec app:app "$0" "$@"
fi

echo "[INFO] Running automatically (${CRON_TIME}), started at $(date +"%F %r")." > "$LOGS_FILE"
tail -F "$LOGS_FILE" # Keeps terminal open and writes logs.
