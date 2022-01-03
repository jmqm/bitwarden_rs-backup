#!/bin/sh

SCRIPT_CMD="/sbin/su-exec ${UID}:${GID} /app/script.sh"
LOGS_FILE="/app/log/log.log"

# If passed "manual", run script once ($1 = First argument passed).
if [ "$1" = "manual" ]; then
    echo "[$(date +"%F %r")] Running one-time."
    $SCRIPT_CMD
    exit 0
fi

# Create cron jobs if root.
if [ "$(id -u)" -eq 0 ]; then
    # Clear cron jobs.
    echo "" | crontab -
    echo "[$(date +"%F %r")] Cron jobs cleared."

    # Add script to cron jobs.
    (crontab -l 2>/dev/null; echo "$CRON_TIME $SCRIPT_CMD >> $LOGS_FILE 2>&1") | crontab -
    echo "[$(date +"%F %r")] Added script to cron jobs."
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

echo "[$(date +"%F %r")] Running automatically (${CRON_TIME})." > "$LOGS_FILE"
tail -F "$LOGS_FILE" # Keeps terminal open and writes logs.
