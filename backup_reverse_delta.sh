#!/bin/bash

# PostgreSQL details
DB_NAME="your_db"
USER="your_username"
PASS="your_password"
HOST="postgres"
PORT="5432"
TABLE_NAME="sample_data"

# Backup directory
BACKUP_DIR="./backups/reverse_delta"
mkdir -p $BACKUP_DIR

# Check if last_full_backup_date.txt exists
# This file should be updated every time a full backup is taken
if [ ! -f "$BACKUP_DIR/last_full_backup_date.txt" ]; then
    echo "Please ensure the last full backup date is set in last_full_backup_date.txt."
    exit 1
fi

# Read the last full backup date
LAST_FULL_BACKUP_DATE=$(cat "$BACKUP_DIR/last_full_backup_date.txt")
echo "$BACKUP_DIR/last_full_backup_date.txt"
echo "$LAST_FULL_BACKUP_DATE"

# Current date for the next backup reference
CURRENT_DATE=$(date -u +"%Y-%m-%d %H:%M:%S")

# File name for the new backup
REVERSE_DELTA_BACKUP_FILE_NAME="delta_${CURRENT_DATE//[: ]/_}.csv"
BACKUP_PATH="$BACKUP_DIR/$REVERSE_DELTA_BACKUP_FILE_NAME"

# Export data modified since last full backup
# same contents, bc i'm using append-only db
# if there were deletions we would have reverted it with inserts
# but for now it's 1-1 copy of differential backup
docker compose exec -T $HOST psql -U $USER -d $DB_NAME \
    -c "COPY (SELECT * FROM $TABLE_NAME WHERE created_at > '$LAST_FULL_BACKUP_DATE') TO STDOUT WITH CSV HEADER" > "$BACKUP_PATH"

# Check if the backup command was successful
if [ $? -eq 0 ]; then
    echo "Reverse Delta Backup successful."
else
    echo "Reverse Delta Backup failed."
    rm $REVERSE_DELTA_BACKUP_FILE_NAME
fi
