#!/bin/bash

set -o errexit \
    -o pipefail \
    -o xtrace

declare -r PROJECT_ID=$1
[[ -z "${PROJECT_ID// }" ]] && exit

declare -r SOURCE_DATASET_NAME=$2
[[ -z "${SOURCE_DATASET_NAME// }" ]] && exit

declare -r TARGET_DATASET_NAME=$3
[[ -z "${TARGET_DATASET_NAME// }" ]] && exit

declare -r TABLE_NAME=$4
[[ -z "${TABLE_NAME// }" ]] && exit

delatable_rows_query_file_name=queries/delatable_records.sql
data_delete_query_file_name=queries/data_delete_query.sql

delete_table_postfix=_deletable
backup_table_postfix=_backup

backup_table_name=${PROJECT_ID}:${TARGET_DATASET_NAME}.${TABLE_NAME}${backup_table_postfix}
deletable_table_name=${PROJECT_ID}:${TARGET_DATASET_NAME}.${TABLE_NAME}${delete_table_postfix}

# read table query from file
deletable_rows_query=`cat "$delatable_rows_query_file_name"`
data_delete_query=`cat "$data_delete_query_file_name"`

# running the command
function run(){
    local command=$1
    eval "$command"
}

# running the command
function replace_table_run(){
    local param=$1
    local t_name="${PROJECT_ID}.${SOURCE_DATASET_NAME}.${TABLE_NAME}"
    local command=${param//BQ_TABLE_NAME/$t_name}
    run "$command"
}

# Backup original table in new table-> creation of backup table 
backup_table_cmd="bq cp ${PROJECT_ID}:${SOURCE_DATASET_NAME}.${TABLE_NAME} $backup_table_name"
run "$backup_table_cmd"

# Copy all deletable records in a backup table for deletable data
copy_deletable_rows_cmd="bq query --destination_table $deletable_table_name --replace --use_legacy_sql=false '"$deletable_rows_query"'"
replace_table_run "$copy_deletable_rows_cmd"

# Delete all duplicate records
delete_duplicate="bq query --use_legacy_sql=false '"$data_delete_query"'"
replace_table_run "$delete_duplicate"

