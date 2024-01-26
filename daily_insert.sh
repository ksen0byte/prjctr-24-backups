#!/bin/bash

# PostgreSQL details
HOST="localhost"
PORT="5432"
DB_NAME="your_db"
USER="your_username"
PASS="your_password"

# Number of records to insert, default is 1 if not provided
NUM_RECORDS=${1:-1}

# Function to insert data
insert_data() {
    RANDOM_DATA=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
    PGPASSWORD=$PASS psql -h $HOST -p $PORT -U $USER -d $DB_NAME -c "INSERT INTO sample_data (data) VALUES ('$RANDOM_DATA');"
}

# Insert the specified number of records
for (( i=0; i<$NUM_RECORDS; i++ ))
do
    insert_data
done
