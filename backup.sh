#!/bin/sh
cd /

# Store new backup archive location in a variable.
BACKUP_LOCATION=/backups/$(date +"%F_%H-%M-%S").tar.xz

# Create variables for the files and directories to be archived.
BACKUP_DB=db.sqlite3 # file
BACKUP_RSA=rsa_key* # files
BACKUP_CONFIG=config.json # file
BACKUP_ATTACHMENTS=attachments # directory
BACKUP_SENDS=sends # directory

# Create an archive of the files and directories.
cd /data && tar -Jcf $BACKUP_LOCATION $BACKUP_DB $BACKUP_RSA $BACKUP_CONFIG $BACKUP_ATTACHMENTS $BACKUP_SENDS 2>/dev/null && cd /
echo "[INFO] Created a new backup on $(date +"%F %r")."
