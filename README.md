Backs up vaultwarden files and directories to `tar.xz` archives automatically. `tar.xz` archives can be opened using data compression programs like [7-Zip](https://www.7-zip.org/) and [WinRAR](https://www.win-rar.com/).

Files and directories that are backed up:
- db.sqlite3
- config.json
- rsa_key.der
- rsa_key.pem
- rsa_key.pub.der
- /attachments
- /sends

## Usage

#### Automatic Backups
Refer to the `docker-compose` section below. By default, backing up is automatic.

#### Manual Backups
Pass `manual` to `docker run` or `docker-compose` as a `command`.

## docker-compose
```
services:
  vaultwarden:
    # Vaultwarden configuration here.
  backup:
    image: jmqm/vaultwarden_backup:latest
    container_name: vaultwarden_backup
    volumes:
      - /vaultwarden_data_directory:/data:ro # Read-only
      - /backup_directory:/backups

      - /etc/localtime:/etc/localtime:ro # Container uses date from host.
    environment:
      - DELETE_AFTER=30
      - CRON_TIME=* */24 * * * # Runs at 12:00 AM.
      - UID=1024
      - GID=100
```

## Volumes
`/data` - Vaultwarden's `/data` directory. Recommend setting mount as read-only.

`/backups` - Where to store backups to.

## Environment Variables
#### ⭐Required, 👍 Recommended
| Environment Variable | Info                                                                                                                                  |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| UID                ⭐| User ID to run the cron job as.                                                                                                       |
| GID                ⭐| Group ID to run the cron job as.                                                                                                      |
| CRON_TIME          👍| When to run (default is every 12 hours). Info [here](https://www.ibm.com/docs/en/db2oc?topic=task-unix-cron-format) and editor [here](https://crontab.guru/). |
| DELETE_AFTER       👍| Delete backups _X_ days old. _(exclusive to automatic mode)_                                                                            |

❗ User must have read permission for `/data` directory and read, write and delete permissions for `/backups`.

#### Optional
| Environment Variable | Info                                                                                         |
| -------------------- | -------------------------------------------------------------------------------------------- |
| TZ ¹                 | Timezone inside the container. Can mount `/etc/localtime` instead as well _(recommended)_.   |

¹ See <https://en.wikipedia.org/wiki/List_of_tz_database_time_zones> for more information

## Errors
#### Unexpected timestamp
Mount `etc/localtime` _(recommend mounting as read-only)_ or set `TZ` environment variable.
