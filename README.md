# Backups

## Overview
The 24-Backups project provides a comprehensive backup solution for PostgreSQL databases, implementing various backup strategies including full, incremental, differential, reverse delta, and continuous data protection (CDP). This setup ensures robust data protection and recovery capabilities, catering to different backup and restoration needs.

## Components
- **Scripts:**
  - `backup_full.sh`: Performs a full backup of the database.
  - `backup_incremental.sh`: Carries out an incremental backup, saving changes since the last backup.
  - `backup_differential.sh`: Conducts a differential backup, capturing all changes since the last full backup.
  - `backup_reverse_delta.sh`: Implements a reverse delta backup, storing reverse changes since the last full backup.
  - `backup_cdp.sh`: Executes continuous data protection by frequently backing up new data.
  - `daily_insert.sh`: Inserts random data into the database daily.
- **Docker Compose File (`docker-compose.yml`):** Sets up PostgreSQL and Adminer services.
- **SQL Initialization (`sql/01_init.sql`):** Contains SQL commands to initialize the database with a sample table and data.
- **Backup Directories:** Separate directories for each backup type (`cdp`, `differential`, `full`, `incremental`, `reverse_delta`).

## Backup Strategy Comparison

### 1. Size
- **Full Backup:** Largest in size as it contains a complete copy of the database.
- **Incremental Backup:** Generally small as it only includes changes since the last backup.
- **Differential Backup:** Size grows over time as it accumulates all changes since the last full backup.
- **Reverse Delta Backup:** Similar in concept to differential backups; size varies based on changes.
- **CDP:** Size depends on the frequency and volume of new data; can grow quickly.

### 2. Ability to Roll Back at Specific Time Point
- **Full Backup:** Basis for other backups, no specific time point roll back.
- **Incremental Backup:** Can roll back to specific points by combining with full backup.
- **Differential Backup:** Enables restoration to the point of the last differential backup.
- **Reverse Delta Backup:** Flexible, can roll back to various points based on deltas.
- **CDP:** Highly flexible, offers near real-time point-in-time recovery.

### 3. Speed of Roll Back
- **Full Backup:** Fast for complete restoration, no incremental data to apply.
- **Incremental Backup:** Slower, requires sequential application of all backups since the last full backup.
- **Differential Backup:** Faster than incremental as only the last differential backup is needed.
- **Reverse Delta Backup:** Speed varies; applying multiple deltas can be time-consuming.
- **CDP:** Potentially very fast, especially for recent data.

### 4. Cost
- **Full Backup:** High storage cost due to size.
- **Incremental Backup:** Lower cost due to smaller size.
- **Differential Backup:** Higher cost over time as backup size increases.
- **Reverse Delta Backup:** Cost varies, potentially higher due to complexity.
- **CDP:** High cost for storage and potentially for compute resources due to continuous operation.

## Conclusion
This project offers a variety of backup solutions to cater to different needs. The choice of backup strategy should be based on specific requirements regarding restoration time, storage efficiency, and data recency.