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

Makes a backup of a running libvirt virtual machine to a local dir, using the libvirt backup API (`virsh backup-begin`). QEMU makes a point-in-time copy of each disk while the VM keeps running on its own disks; no snapshots or overlays are involved. Meant to be followed by `backup2surfsara` (duplicity), which takes care of incremental backups.

* Please don't use this on your production VMs without proper testing!
* Requires libvirt >= 6.0 and QEMU >= 4.2.
* Supports multiple disks per VM; cdroms etc. are skipped.
* Can back up all running VMs with `--all`.
* Each disk is backed up as a sparse file with the name and format (qcow2 or raw) of the original image, replacing the previous backup, so the target dir does not fill up.
* The persistent VM definition is saved as `<vm>.xml`.
* Refuses to back up into a dir that contains VM images (of any VM), so the originals can never be overwritten. Two disks with the same file name are refused too.
* With the qemu-guest-agent installed in the VM, filesystems are frozen just for the moment the backup starts.
* The target dir must be writable for QEMU (and allowed by SELinux/AppArmor).
