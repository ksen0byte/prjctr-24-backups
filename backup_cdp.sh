#!/bin/bash

# Database connection details
DB_NAME="your_db"
USER="your_username"
HOST="postgres"
TABLE_NAME="sample_data"
TIMESTAMP_COLUMN="created_at"  # Column that records when a row was added

# Backup directory
BACKUP_DIR="./backups/cdp"
mkdir -p $BACKUP_DIR

# Interval in seconds for checking new data (e.g., every 5 seconds)
INTERVAL=5

# Function to backup new data
backup_new_data() {
    # Current timestamp
    CURRENT_TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S")

    # Backup file name
    BACKUP_PATH="$BACKUP_DIR/backup_$CURRENT_TIMESTAMP.csv"

    # Export data modified since last backup
    docker compose exec -T $HOST psql -U $USER -d $DB_NAME \
        -c "COPY (SELECT * FROM $TABLE_NAME WHERE created_at > '$LAST_CHECKED') TO STDOUT WITH CSV HEADER" > "$BACKUP_PATH"

    echo "Backup completed for data until $CURRENT_TIMESTAMP"
}

# Initialize last checked timestamp
LAST_CHECKED=$(date -u +"2000-01-01 00:00:00")

# Main loop
while true; do
    backup_new_data
    LAST_CHECKED=$(date -u +"%Y-%m-%d %H:%M:%S")
    sleep $INTERVAL
done
