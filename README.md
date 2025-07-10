# Debian System Backup and Restore Script (Version 3.0)

This repository contains an enhanced shell script for backing up and restoring key system elements of a Debian-based system. It is useful for creating a recovery point before making significant changes to the system.

## Features

- Backs up the list of installed packages with verification
- Backs up configuration files in `/etc` with compression
- Optionally: Backs up the entire file system (with configurable exclusions)
- Provides a restore function to revert the system to the saved state
- Comprehensive logging with detailed error reporting
- **New in v3.0**: Enhanced error handling and validation
- **New in v3.0**: Permission checks and file size verification
- **New in v3.0**: Improved debugging capabilities

## Requirements

- A Debian-based system (e.g., Debian, Ubuntu)
- Sufficient disk space for the backup
- Write permissions to the backup directory (typically `/backup`)
- Root privileges for system-wide operations

## Installation

### 1. Clone the repository

Clone this repository to your local machine:
```sh
git clone https://github.com/VolkanSah/Debian-System-Backup-and-Restore-Script
cd Debian-System-Backup-and-Restore-Script
```

### 2. Set up backup directory

Create and configure the backup directory:
```sh
sudo mkdir -p /backup
sudo chown $(whoami):$(whoami) /backup
sudo chmod 755 /backup
```

### 3. Make the script executable

Ensure the script has execution permissions:
```sh
chmod +x backup_script.sh
```

## Usage

### Backup Operations

#### Standard Backup
To create a backup of packages and configuration files:
```sh
./backup_script.sh backup
```

#### Full System Backup
For a complete file system backup:
```sh
./backup_script.sh backup full
```

**What happens during backup:**
- Creates a timestamped backup directory in `/backup/YYYYMMDD_HHMMSS`
- Saves the list of installed packages to `installed_packages.list`
- Compresses and stores configuration files from `/etc` into `etc_backup.tar.gz`
- Optionally backs up the entire file system (if "full" is specified)
- Generates detailed logs in `backup.log`

### Restore Operations

#### Standard Restore
To restore packages and configuration files from a backup:
```sh
./backup_script.sh restore /backup/YYYYMMDD_HHMMSS
```

#### Full System Restore
For a complete system restore:
```sh
./backup_script.sh restore /backup/YYYYMMDD_HHMMSS full
```

**What happens during restore:**
- Restores the list of installed packages and installs missing ones
- Extracts and restores configuration files from `etc_backup.tar.gz`
- Optionally restores the entire file system (if "full" is specified)
- Logs all restoration activities

## Troubleshooting

### Common Issues and Solutions

#### Empty Backup Files
If backup files are created but remain empty:

1. **Check permissions:**
   ```sh
   ls -ld /backup
   sudo chown $(whoami):$(whoami) /backup
   ```

2. **Run with debug output:**
   ```sh
   bash -x ./backup_script.sh backup
   ```

3. **Check log file:**
   ```sh
   tail -f /backup/YYYYMMDD_HHMMSS/backup.log
   ```

#### Permission Denied Errors
- Ensure you have write permissions to `/backup`
- Run restore operations with `sudo` when needed
- Check that the script is executable

#### Backup Verification
The script now includes automatic verification:
- Checks if backup directory is writable
- Verifies file creation and sizes
- Logs detailed error messages

## Script Architecture

### Version 3.0 Improvements

- **Enhanced Error Handling**: `check_command()` function validates each operation
- **Permission Validation**: Checks directory permissions before operations
- **File Verification**: Confirms files are created and contain data
- **Detailed Logging**: Comprehensive logging with timestamps and file sizes
- **Debug Support**: Better error reporting and troubleshooting information

### Exclusion List for Full Backups

The script automatically excludes these directories from full backups:
- `/proc/*` - Process information
- `/sys/*` - System information
- `/dev/*` - Device files
- `/tmp/*` - Temporary files
- `/run/*` - Runtime data
- `/mnt/*` - Mount points
- `/media/*` - Removable media
- `/lost+found` - File system recovery
- `/backup/*` - Backup directory itself

## Best Practices

### Before Using the Script
- **Test on a non-production system first**
- **Ensure adequate disk space** (full backups can be large)
- **Verify backup integrity** after creation
- **Document your backup schedule**

### Regular Maintenance
- **Clean old backups** regularly to save disk space
- **Test restore procedures** periodically
- **Monitor backup logs** for errors or warnings
- **Keep the script updated** to the latest version

## Advanced Usage

### Automated Backups
Add to crontab for automated backups:
```sh
# Daily backup at 2 AM
0 2 * * * /path/to/backup_script.sh backup >> /var/log/backup_cron.log 2>&1

# Weekly full backup on Sundays at 3 AM
0 3 * * 0 /path/to/backup_script.sh backup full >> /var/log/backup_cron.log 2>&1
```

### Custom Backup Location
Modify the `BACKUP_DIR` variable in the script to use a different location:
```sh
BACKUP_DIR="/custom/backup/path/$(date +%Y%m%d_%H%M%S)"
```

## Changelog

### Version 3.0 (Current)
- Added comprehensive error handling with `check_command()` function
- Implemented permission checks for backup directory
- Added file size verification and logging
- Enhanced debugging capabilities with detailed error messages
- Improved log file structure with operation status tracking
- Added backup summary with file listings

### Version 2.0
- Detailed logging of all actions
- Configurable options for important settings
- An exclusion list for full backups
- Improved structure with separate functions for backup and restore
- Flexible options for normal and full backup/restore
- Basic error handling and checks

### Version 1.0
- Added full system backup capability
- Implemented restore functionality
- Added configuration file backup

### Version 0.1
- Initial release with basic package backup functionality

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## License

This project is open source and available under the MIT License.

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review the log files for detailed error messages
3. Open an issue on GitHub with your log files and system information


If you find this project helpful and would like to support it, there are several ways to do so:

- If you find this script useful, please give it a ⭐ on GitHub. This helps make the project more visible and reach more people.
- Follow me: If you're interested in updates and future improvements, please follow my GitHub account to stay informed.
- Learn more about my work: I invite you to view all my work on GitHub and visit my developer website at https://volkansah.github.io. There, you'll find detailed information about me and my projects.
- Share the project: If you know someone who could benefit from this project, please share it. The more people who can use it, the better.

**If you appreciate my work and would like to support it, please visit my [GitHub Sponsor page](https://github.com/sponsors/volkansah). Any kind of support is greatly appreciated and helps me improve and expand my work.**

Thank you for your support! ❤️

##### Copyright S. Volkan Kücükbudak
