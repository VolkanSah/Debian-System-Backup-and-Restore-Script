#!/bin/bash

# Create backup directory
BACKUP_DIR="/backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Save the list of installed packages
dpkg --get-selections > "$BACKUP_DIR/installed_packages.list"
echo "Package list saved to $BACKUP_DIR/installed_packages.list"

# Backup configuration files
tar czf "$BACKUP_DIR/etc_backup.tar.gz" /etc
echo "Configuration files saved to $BACKUP_DIR/etc_backup.tar.gz"

# Optional: Backup the entire filesystem (can consume a lot of space)
# tar czf "$BACKUP_DIR/full_backup.tar.gz" --exclude="$BACKUP_DIR" /

# Backup complete
echo "Backup complete. All important files are saved in $BACKUP_DIR."

# Restore function
restore() {
    BACKUP_DIR="$1"
    if [ -z "$BACKUP_DIR" ]; then
        echo "Please specify the backup directory."
        exit 1
    fi

    # Restore the list of installed packages
    sudo dpkg --set-selections < "$BACKUP_DIR/installed_packages.list"
    sudo apt-get -y dselect-upgrade
    echo "Package list restored."

    # Restore configuration files
    tar xzf "$BACKUP_DIR/etc_backup.tar.gz" -C /
    echo "Configuration files restored."

    # Optional: Restore the entire filesystem
    # tar xzf "$BACKUP_DIR/full_backup.tar.gz" -C /
}

# Automatic restore if an argument is provided
if [ "$1" == "restore" ]; then
    restore "$2"
fi
