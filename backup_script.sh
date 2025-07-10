#!/bin/bash
# Configuration
BACKUPDIR="/backup/$(date +%Y%m%d%H%M%S)"
LOG_FILE="$BACKUP_DIR/backup.log"
EXCLUDE_FILE="/tmp/backup_exclude.txt"
# Function for logging
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}
# Backup function
backup() {
    mkdir -p "$BACKUP_DIR"
    log "Backup started in $BACKUP_DIR"
    # Save list of installed packages
    dpkg --get-selections > "$BACKUP_DIR/installed_packages.list"
    log "Package list saved in $BACKUP_DIR/installed_packages.list"
    # Backup configuration files
    tar czf "$BACKUP_DIR/etc_backup.tar.gz" /etc
    log "Configuration files backed up in $BACKUP_DIR/etc_backup.tar.gz"
    # Create exclusion list
    cat << EOF > "$EXCLUDE_FILE"
/proc/*
/sys/*
/dev/*
/tmp/*
/run/*
/mnt/*
/media/*
/lost+found
/backup/*
EOF
    # Back up entire file system (optional)
    if [ "$FULL_BACKUP" = true ]; then
        log "Starting full backup..."
        tar czf "$BACKUP_DIR/full_backup.tar.gz" --exclude-from="$EXCLUDE_FILE" /
        log "Full backup completed: $BACKUP_DIR/full_backup.tar.gz"
    fi
    log "Backup completed."
}
# Restore function
restore() {
    local restore_dir="$1"
    if [ -z "$restore_dir" ]; then
        log "Please specify the backup directory."
        exit 1
    fi
    log "Starting restore from $restore_dir"
    # Restore package list
    if [ -f "$restore_dir/installed_packages.list" ]; then
        sudo dpkg --set-selections < "$restore_dir/installed_packages.list"
        sudo apt-get -y dselect-upgrade
        log "Package list restored."
    else
        log "Warning: Package list not found."
    fi
    # Restore configuration files
    if [ -f "$restore_dir/etc_backup.tar.gz" ]; then
        sudo tar xzf "$restore_dir/etc_backup.tar.gz" -C /
        log "Configuration files restored."
    else
        log "Warning: Configuration files backup not found."
    fi
    # Restore entire file system (optional)
    if [ "$FULL_RESTORE" = true ] && [ -f "$restore_dir/full_backup.tar.gz" ]; then
        log "Starting full restore..."
        sudo tar xzf "$restore_dir/full_backup.tar.gz" -C /
        log "Full restore completed."
    fi
    log "Restore completed."
}
# Main program
case "$1" in
    backup)
        FULL_BACKUP=false
        [ "$2" = "full" ] && FULL_BACKUP=true
        backup
        ;;
    restore)
        FULL_RESTORE=false
        [ "$3" = "full" ] && FULL_RESTORE=true
        restore "$2"
        ;;
    *)
        echo "Usage: $0 {backup|restore} [options]"
        echo "  backup [full]  - Performs a backup (optional: full backup)"
        echo "  restore DIR [full] - Restores from the specified directory"
        exit 1
        ;;
esac
exit 0 script selbst liegt in /batscripts  und backups in /backup
