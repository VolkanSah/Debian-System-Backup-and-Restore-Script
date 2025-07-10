#!/bin/bash
# Configuration
BACKUP_DIR="/backup/$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$BACKUP_DIR/backup.log"
EXCLUDE_FILE="/tmp/backup_exclude.txt"

# Function for logging
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to check if command succeeded
check_command() {
    if [ $? -eq 0 ]; then
        log "SUCCESS: $1"
    else
        log "ERROR: $1 failed with exit code $?"
        exit 1
    fi
}

# Backup function
backup() {
    # Check if backup directory exists and is writable
    if [ ! -d "/backup" ]; then
        log "ERROR: /backup directory does not exist"
        exit 1
    fi
    
    if [ ! -w "/backup" ]; then
        log "ERROR: No write permission for /backup directory"
        exit 1
    fi
    
    mkdir -p "$BACKUP_DIR"
    check_command "Creating backup directory $BACKUP_DIR"
    
    # Initialize log file
    touch "$LOG_FILE"
    check_command "Creating log file"
    
    log "Backup started in $BACKUP_DIR"
    
    # Save list of installed packages
    log "Saving package list..."
    dpkg --get-selections > "$BACKUP_DIR/installed_packages.list"
    check_command "Saving package list"
    
    # Check if package list was actually created and has content
    if [ ! -s "$BACKUP_DIR/installed_packages.list" ]; then
        log "WARNING: Package list is empty or not created"
    else
        log "Package list saved with $(wc -l < "$BACKUP_DIR/installed_packages.list") packages"
    fi
    
    # Backup configuration files
    log "Backing up /etc directory..."
    tar czf "$BACKUP_DIR/etc_backup.tar.gz" /etc 2>>"$LOG_FILE"
    check_command "Backing up configuration files"
    
    # Check if tar file was created and has reasonable size
    if [ -f "$BACKUP_DIR/etc_backup.tar.gz" ]; then
        size=$(du -h "$BACKUP_DIR/etc_backup.tar.gz" | cut -f1)
        log "Configuration backup created: $size"
    else
        log "ERROR: Configuration backup file not created"
        exit 1
    fi
    
    # Create exclusion list
    log "Creating exclusion list..."
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
    check_command "Creating exclusion list"
    
    # Back up entire file system (optional)
    if [ "$FULL_BACKUP" = true ]; then
        log "Starting full backup..."
        tar czf "$BACKUP_DIR/full_backup.tar.gz" --exclude-from="$EXCLUDE_FILE" / 2>>"$LOG_FILE"
        check_command "Full backup"
        
        if [ -f "$BACKUP_DIR/full_backup.tar.gz" ]; then
            size=$(du -h "$BACKUP_DIR/full_backup.tar.gz" | cut -f1)
            log "Full backup created: $size"
        else
            log "ERROR: Full backup file not created"
            exit 1
        fi
    fi
    
    # Show final backup summary
    log "Backup completed. Files created:"
    ls -lh "$BACKUP_DIR"/ >> "$LOG_FILE"
    
    log "Backup completed successfully."
}

# Restore function
restore() {
    local restore_dir="$1"
    if [ -z "$restore_dir" ]; then
        log "Please specify the backup directory."
        exit 1
    fi
    
    if [ ! -d "$restore_dir" ]; then
        log "ERROR: Backup directory $restore_dir does not exist"
        exit 1
    fi
    
    log "Starting restore from $restore_dir"
    
    # Restore package list
    if [ -f "$restore_dir/installed_packages.list" ]; then
        log "Restoring package list..."
        sudo dpkg --set-selections < "$restore_dir/installed_packages.list"
        check_command "Setting package selections"
        
        sudo apt-get -y dselect-upgrade
        check_command "Installing packages"
        
        log "Package list restored."
    else
        log "Warning: Package list not found."
    fi
    
    # Restore configuration files
    if [ -f "$restore_dir/etc_backup.tar.gz" ]; then
        log "Restoring configuration files..."
        sudo tar xzf "$restore_dir/etc_backup.tar.gz" -C /
        check_command "Restoring configuration files"
        
        log "Configuration files restored."
    else
        log "Warning: Configuration files backup not found."
    fi
    
    # Restore entire file system (optional)
    if [ "$FULL_RESTORE" = true ] && [ -f "$restore_dir/full_backup.tar.gz" ]; then
        log "Starting full restore..."
        sudo tar xzf "$restore_dir/full_backup.tar.gz" -C /
        check_command "Full restore"
        
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
exit 0
