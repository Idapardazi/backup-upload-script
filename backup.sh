#!/bin/bash

# Function to get user input for the directory path
get_path() {
  read -p "Enter the path to backup: " path
  echo $path
}

# Function to create a backup
create_backup() {
  local path=$1
  local backup_path="${path}_backup"
  if [ -d "$backup_path" ]; then
    rm -rf "$backup_path"
  fi
  cp -r "$path" "$backup_path"
  echo $backup_path
}

# Function to compress the backup
compress_backup() {
  local backup_path=$1
  local compressed_path="${backup_path}.tar.gz"
  tar -czf "$compressed_path" -C "$(dirname "$backup_path")" "$(basename "$backup_path")"
  echo $compressed_path
}

# Function to set MinIO alias
set_minio_alias() {
  local minio_server_ip=$1
  local minio_alias=$2
  mc alias set "$minio_alias" "http://$minio_server_ip:9000" minioadmin minioadmin
}

# Function to upload to MinIO
upload_to_minio() {
  local compressed_path=$1
  local bucket_name=$2
  local object_name=$(basename "$compressed_path")
  local minio_alias=$3

  echo "Uploading to MinIO: $compressed_path to $minio_alias/$bucket_name/$object_name"
  mc cp "$compressed_path" "$minio_alias/$bucket_name/$object_name"

  if [ $? -eq 0 ]; then
    echo "Successfully uploaded $compressed_path to $bucket_name/$object_name"
  else
    echo "Failed to upload $compressed_path"
  fi
}

# Main script logic
main() {
  path=$(get_path)

  if [ ! -d "$path" ]; then
    echo "The specified path does not exist."
    exit 1
  fi

  backup_path=$(create_backup "$path")
  compressed_path=$(compress_backup "$backup_path")

  # Configuration
  bucket_name='homework1'
  minio_alias='myminio'  # MinIO alias name
  minio_server_ip='172.17.0.1'  # MinIO server IP address

  set_minio_alias "$minio_server_ip" "$minio_alias"
  upload_to_minio "$compressed_path" "$bucket_name" "$minio_alias"
}

# Run the main function
main

