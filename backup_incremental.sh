#!/bin/bash

# PostgreSQL details
DB_NAME="your_db"
USER="your_username"
PASS="your_password"
HOST="postgres"  # Make sure this matches the service name in docker-compose.yml
PORT="5432"
TABLE_NAME="sample_data"

# Backup directory
BACKUP_DIR="./backups/incremental"
mkdir -p $BACKUP_DIR

# Check if last_backup_date.txt exists, if not create it with a default date
if [ ! -f "$BACKUP_DIR/last_backup_date.txt" ]; then
    echo "2000-01-01 00:00:00" > "$BACKUP_DIR/last_backup_date.txt"
fi

# Read the last backup date
LAST_BACKUP_DATE=$(cat "$BACKUP_DIR/last_backup_date.txt")

# Current date for the next backup reference
CURRENT_DATE=$(date -u +"%Y-%m-%d %H:%M:%S")

# File name for the new backup
INCREMENTAL_BACKUP_FILE_NAME="incremental_backup_since_${LAST_BACKUP_DATE//[: ]/_}_to_${CURRENT_DATE//[: ]/_}.csv"
BACKUP_PATH="$BACKUP_DIR/$INCREMENTAL_BACKUP_FILE_NAME"

# Export data modified since last backup
docker compose exec -T $HOST psql -U $USER -d $DB_NAME \
    -c "COPY (SELECT * FROM $TABLE_NAME WHERE created_at > '$LAST_BACKUP_DATE') TO STDOUT WITH CSV HEADER" > "$BACKUP_PATH"

# Check if the backup command was successful
if [ $? -eq 0 ]; then
    echo "Backup successful."
    # Update the last backup date
    echo $CURRENT_DATE > "$BACKUP_DIR/last_backup_date.txt"
else
    echo "Backup failed."
    rm $INCREMENTAL_BACKUP_FILE_NAME
fi