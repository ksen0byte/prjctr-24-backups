#!/bin/bash

# Database credentials and details
DB_NAME="your_db"
USER="your_username"
PASS="your_password"
HOST="postgres"  # Use the container name or service name from docker-compose
PORT="5432"
TABLE_NAME="sample_data"

# Backup directory and file name
BACKUP_DIR="./backups/full"
BACKUP_FILE_NAME="full_backup_$(date +%Y%m%d_%H%M%S).sql"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_FILE_NAME"

# Current date for the next backup reference
CURRENT_DATE=$(date -u +"%Y-%m-%d %H:%M:%S")

# Run pg_dump within a temporary Docker container
docker compose exec -T $HOST psql -U $USER -d $DB_NAME \
    -c "COPY (SELECT * FROM $TABLE_NAME) TO STDOUT WITH CSV HEADER" > "$BACKUP_PATH"

# Check if the backup command was successful
if [ $? -eq 0 ]; then
    echo "Backup successful."
    # Update the last backup date
    echo $CURRENT_DATE > "$BACKUP_DIR/last_full_backup_date.txt"
else
    echo "Backup failed."
    rm $INCREMENTAL_BACKUP_FILE_NAME
fi
