
# Debian System Backup and Restore Script

This repository contains a shell script to back up and restore important system elements of a Debian-based system. This is useful for creating a rollback point before making significant changes to the system.

## Features
- Backs up the list of installed packages.
- Backs up configuration files in `/etc`.
- Optional: Backs up the entire filesystem (excluding the backup directory itself).
- Provides a restore function to revert the system to the saved state.

## Prerequisites
- A Debian-based system (e.g., Debian, Ubuntu).
- Sufficient disk space for the backup.

## Usage

### 1. Clone the Repository
Clone this repository to your local machine:
```sh
git clone https://github.com/VolkanSah/Debian-System-Backup-and-Restore-Script
cd Debian-System-Backup-and-Restore-Script
```

### 2. Make the Script Executable
Ensure the script has execute permissions:
```sh
chmod +x backup_script.sh
```

### 3. Run the Backup Script
To create a backup, run the script without any arguments:
```sh
./backup_script.sh
```
This will:
- Create a backup directory with a timestamp.
- Save the list of installed packages to `installed_packages.list`.
- Compress and save configuration files from `/etc` to `etc_backup.tar.gz`.
- Optionally, you can uncomment the lines in the script to back up the entire filesystem.

### 4. Restore from a Backup
To restore the system from a backup, run the script with the `restore` argument and the path to the backup directory:
```sh
./backup_script.sh restore /path/to/backup_directory
```
This will:
- Restore the list of installed packages.
- Extract and restore configuration files from `etc_backup.tar.gz`.
- Optionally, uncomment the lines to restore the entire filesystem.

## Script Details

### Backup Script
```bash
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
```

## Recommendations
- **Error Handling**: Add error handling and checks for available disk space before proceeding with the backup.
- **Notifications**: Integrate notifications (e.g., via email) to inform you upon successful backup or restoration.

## License
This project is licensed under the GPLv3 License. See the `LICENSE` file for details.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request for any improvements or suggestions.

## Contact
For any questions or support, please open an issue in the repository.

## Your Support
If you find this project useful and want to support it, there are several ways to do so:

- If you find the white paper helpful, please ⭐ it on GitHub. This helps make the project more visible and reach more people.
- Become a Follower: If you're interested in updates and future improvements, please follow my GitHub account. This way you'll always stay up-to-date.
- Learn more about my work: I invite you to check out all of my work on GitHub and visit my developer site https://volkansah.github.io. Here you will find detailed information about me and my projects.
- Share the project: If you know someone who could benefit from this project, please share it. The more people who can use it, the better.
**If you appreciate my work and would like to support it, please visit my [GitHub Sponsor page](https://github.com/sponsors/volkansah). Any type of support is warmly welcomed and helps me to further improve and expand my work.**

Thank you for your support! ❤️

##### Copyright S. Volkan Kücükbudak
