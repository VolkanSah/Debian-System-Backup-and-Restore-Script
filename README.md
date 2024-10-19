
# Debian System Backup and Restore Script (Version 2.0)

This repository contains a shell script for backing up and restoring key system elements of a Debian-based system. It is useful for creating a recovery point before making significant changes to the system.

## Features
- Backs up the list of installed packages.
- Backs up configuration files in `/etc`.
- Optionally: Backs up the entire file system (with configurable exclusions).
- Provides a restore function to revert the system to the saved state.
- Logs all actions in detail.

## Requirements
- A Debian-based system (e.g., Debian, Ubuntu).
- Sufficient disk space for the backup.

## Usage

### 1. Clone the repository
Clone this repository to your local machine:
```sh
git clone https://github.com/VolkanSah/Debian-System-Backup-and-Restore-Script
cd Debian-System-Backup-and-Restore-Script
```

### 2. Make the script executable
Ensure the script has execution permissions:
```sh
chmod +x backup_script.sh
```

### 3. Run the backup script
To create a backup, run the script with the `backup` argument:
```sh
./backup_script.sh backup
```
For a full file system backup:
```sh
./backup_script.sh backup full
```

This will:
- Create a timestamped backup directory.
- Save the list of installed packages to `installed_packages.list`.
- Compress and store configuration files from `/etc` into `etc_backup.tar.gz`.
- Optionally back up the entire file system (if "full" is specified).

### 4. Restore from a backup
To restore the system from a backup, run the script with the `restore` argument and the path to the backup directory:
```sh
./backup_script.sh restore /path/to/backup_directory
```
For a full system restore:
```sh
./backup_script.sh restore /path/to/backup_directory full
```

This will:
- Restore the list of installed packages.
- Extract and restore configuration files from `etc_backup.tar.gz`.
- Optionally restore the entire file system (if "full" is specified).

## Script Details

The updated script offers the following improvements:
- Detailed logging of all actions.
- Configurable options for important settings.
- An exclusion list for full backups.
- Improved structure with separate functions for backup and restore.
- Flexible options for normal and full backup/restore.
- Enhanced error handling and checks.

## Recommendations
- **Error Handling**: The script now includes basic error handling. Consider adding further checks, such as for available disk space.
- **Notifications**: Integrate notifications (e.g., via email) to inform you of successful backups or restores.

## License
This project is licensed under the GPLv3 license. See the `LICENSE` file for details.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request for improvements or suggestions.

## Contact
For questions or support, please open an issue in the repository.

## Supporting the Project
If you find this project helpful and would like to support it, there are several ways to do so:

- If you find this script useful, please give it a ⭐ on GitHub. This helps make the project more visible and reach more people.
- Follow me: If you're interested in updates and future improvements, please follow my GitHub account to stay informed.
- Learn more about my work: I invite you to view all my work on GitHub and visit my developer website at https://volkansah.github.io. There, you'll find detailed information about me and my projects.
- Share the project: If you know someone who could benefit from this project, please share it. The more people who can use it, the better.

**If you appreciate my work and would like to support it, please visit my [GitHub Sponsor page](https://github.com/sponsors/volkansah). Any kind of support is greatly appreciated and helps me improve and expand my work.**

Thank you for your support! ❤️

##### Copyright S. Volkan Kücükbudak
