# Backup scripts
Some scripts to back up systems.

## install-duplicity

This script will install the latest greatest Duplicity on RHEL/Centos 7, including lots of dependencies for backends such as Swift and Google Drive.

## backup2surfsara

A wrapper for Duplicity to more easily maintain your Duplicity backups.

* /etc/backup2surfsara[.swift|.webdav]
  * Contains (connection) password and (encryption) passphrase.
    * For this reason, the file should be 600; if it's more open than that, backup2surfsara will refuse to run.
  * Contains the backend settings.
  * Contains a list of directories to exclude from the backup, like `/proc` and `/tmp`. A notible one is `/root/.cache`, which contains lots of Duplicity files that are already in the backup!
  * You can specify commands that need to be executed before the backup or after the backup.
  * Currently there are two flavors for this file: one for a swift backend and one for a webdav backend. But Duplicity supports many more.
* /usr/local/sbin/backup2surfsara
  * Loads the configuration from /etc/backup2surfsara
  * Runs the backup (full if it's the first time, incremental after that)
  * When a backup chain becomes longer than a specified interval, a full backup is made again to start a new chain
  * After a specified interval, old chains are removed
  * With `--report`, generates a report about the backups that have been made
  * With `--check`, it works as a Nagios/Icinga plugin to check if the latest backup is recent enough

## libvirt-live-backup

Makes a backup of a running libvirt virtual machine. This is done by making a snapshot, copying that to a rsync compatible location (a /path or hostname:/path), and then cleaning up the snapshot.

* Tested on Centos 7, but please don't use this on your production VMs without proper testing!
* Supports multiple disks per VM.
* Can back up all running VMs with `--all`.

To enable libvirt snapshots, you need a Qemu version from the centos-release-qemu-ev repo.

    yum -y install centos-release-qemu-ev
    yum -y install qemu-kvm-ev

And then I'm afraid you need to reboot your VM host; a restart of `libvirtd` is not enough.

Known issue:

* During snapshot, the VM may freeze for a while. This could interrupt connections.
