#!/bin/bash
# Configuration for backup script

DUPLICITY_OPTIONS=''
SOURCE=/
EXCLUDE=( /proc \
          /sys \
          /tmp \
          /var/tmp \
          /var/log \
          /var/www/cobbler/repo_mirror \
          /var/cache \
          /root/.cache/ \
          /home/*/.cache \
          /home/*/nobackup \
          /home/*/Downloads \
        )

BACKUPPROTO=swift://

# Swift credentials. Use the settings from the environment, or enter your own values.
export SWIFT_USERNAME="$OS_PROJECT_NAME:$OS_USERNAME"
export SWIFT_PASSWORD="$OS_PASSWORD"
export SWIFT_AUTHURL="$OS_AUTH_URL"
export SWIFT_AUTHVERSION="$OS_AUTH_VERSION"


# Password to encrypt backups
export PASSPHRASE=''

# Make a new chain after how much time?
export BACKUPCHAINLENGTH='1M'

# With --check, what is the reference date? See 'man date' for syntax. Default: '30 hours ago'.
#export REF_DATE='30 hours ago'
