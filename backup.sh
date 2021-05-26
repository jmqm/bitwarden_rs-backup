#!/bin/sh

TIMESTAMP=$(date "+%F_%H.%M.%S")

# Create variable for new backup archived.
BACKUP_ZIP=/backups/$TIMESTAMP.zip
BACKUP_TARXZ=/backups/$TIMESTAMP.tar.xz

# Create variables for the files and directories to be archived.
BACKUP_DB=db.sqlite3 # file
BACKUP_RSA=rsa_key* # files
BACKUP_CONFIG=config.json # file
BACKUP_ATTACHMENTS=attachments # directory
BACKUP_SENDS=sends # directory

# Create an archive of the files and directories.
echo "Starting backup at ${TIMESTAMP}..."
cd /data && zip -r $BACKUP_ZIP $BACKUP_DB $BACKUP_RSA $BACKUP_CONFIG $BACKUP_ATTACHMENTS $BACKUP_SENDS && cd ..
cd /data && tar -Jcf $BACKUP_TARXZ $BACKUP_DB $BACKUP_RSA $BACKUP_CONFIG $BACKUP_ATTACHMENTS $BACKUP_SENDS && cd ..
echo "Backup completed at ${TIMESTAMP}."
