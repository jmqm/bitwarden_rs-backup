#!/bin/sh
cd /

# Create a variable for new backup archive.
BACKUP_LOCATION=/backups/$(date "+%F_%H.%M.%S").tar.xz

# Create variables for the files and directories to be archived.
BACKUP_DB=db.sqlite3
BACKUP_RSA=rsa_key*
BACKUP_CONFIG=config.json
BACKUP_ATTACHMENTS=./attachments
BACKUP_SENDS=./sends

# Create an archive of the files and directories.
echo "Starting backup at $date..."
cd /data && tar -Jcf $BACKUP_LOCATION $BACKUP_DB $BACKUP_RSA $BACKUP_CONFIG $BACKUP_ATTACHMENTS $BACKUP_SENDS && cd -
echo "Backup completed at $date."
