#!/bin/bash
# Configuration for backup script

SOURCE=/a
EXCLUDE=( /proc \
          /sys \
          /tmp \
          /var/tmp \
          /var/log \
          /var/www/cobbler/repo_mirror \
          /root/.cache/ \
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
