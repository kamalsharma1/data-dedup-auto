# big-query-backup and de-duplicate-table-data-automation
Bash script to backup table & delete duplicate rows in a google big query table

## Working on

- Linux
- OSX

## Getting Started

### Usage

Step1: Copy the `run.sh`, `data_delete_query.sql` and `delatable_records.sql` files locally or the server where you have gcloud installed & [authenticated](https://cloud.google.com/sdk/gcloud/reference/init).

Step2: 
`./run.sh [PROJECT-ID] [SOURCE_DATASET_NAME] [TARGET_DATASET_NAME] [TABLE_NAME]`

### Info
Backup tables are created in the [TARGET_DATASET_NAME] bigquery dataset.
