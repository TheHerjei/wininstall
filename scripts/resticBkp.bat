@echo off

SETLOCAL
SET RESTIC_REPOSITORY="sftp:USER@HOST:/XXXXX-restic-repo-path-XXXX"
SET RESTIC_PASSWORD="XXXXXXXXXX"
SET BACKUP_ORIGIN="/PATH-TO-DOCS-TO-BACKUP/"

restic backup %BACKUP_ORIGIN%
restic forget --keep-last 24 --keep-daily 6 --keep-monthly 6 --keep-weekly 4