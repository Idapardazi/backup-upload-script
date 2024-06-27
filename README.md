# Backup and Upload Script

This project provides a Bash script to create a backup of a specified directory, compress the backup, and upload it to a MinIO bucket. It is designed to automate the backup process and ensure that your important data is securely stored.

## Features

- Prompt the user to specify a directory to back up
- Create a backup of the specified directory
- Compress the backup into a `.tar.gz` file
- Upload the compressed backup to a MinIO bucket

## Prerequisites

- [MinIO](https://min.io/) should be installed and running
- MinIO client (`mc`) should be installed and configured on your system
- Bash shell (default on most Unix-like operating systems)

## Usage

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/backup-upload-script.git
cd backup-upload-script
