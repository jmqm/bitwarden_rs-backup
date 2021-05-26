Backs up vaultwarden files and folders to `tar.xz` archives.
Can be set to run automatically.

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
    image: jmqm/vaultwarden_backup
    container_name: vaultwarden_backup
    volumes:
      - "/vaultwarden_data_directory:/data:ro" # Read-only
      - "/backup_directory:/backups"

      - "/etc/localtime:/etc/localtime:ro" # Container uses date from host.
    environment:
      - DELETE_AFTER=30 #optional
      - CRON_TIME=* */24 * * * # Runs every 24 hours.
      - UID=1024
      - GID=100
```

## Volumes
`/data` - Vaultwarden's `/data` folder. Recommend setting mount as read-only.

`/backups` - Where to store backups to.

## Environment Variables
#### ⭐Required, 👍 Recommended
| Environment Variable       | Description                                                                                                                           |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| UID                      ⭐| User ID to run the cron job as.                                                                                                       |
| GID                      ⭐| Group ID to run the cron job as.                                                                                                      |
| CRON_TIME                👍| When to run (default is every 12 hours). Info [here](https://www.ibm.com/docs/en/db2oc?topic=task-unix-cron-format) and editor [here](https://crontab.guru/). |
| DELETE_AFTER 👍| Delete backups _X_ days old. _(unsupported at the moment)_                                                                            |

#### Optional
| Environment Variable       | Description                                                                                  |
| -------------------------- | -------------------------------------------------------------------------------------------- |
| TZ ¹           	     | Timezone inside the container. Can mount `/etc/localtime` instead as well _(recommended)_.   |
| LOGFILE        	     | Log file path relative to inside the container.                                              |
| CRONFILE       	     | Cron file path relative to inside the container.                                             |

¹ See <https://en.wikipedia.org/wiki/List_of_tz_database_time_zones> for more information

## Errors
#### Unexpected timestamp
Mount `etc/localtime` _(recommend mounting as read-only)_ or set `TZ` environment variable.
