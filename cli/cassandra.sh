
alias cqlLocal="cqlsh -u cassandra -p cassandra -k ole_inventory_local --cqlversion=3.4.4 127.0.0.1"
alias cqlDev="cqlsh -u $CQL_USERNAME_DEV -p '$CQL_PASSWORD_DEV' -k ole_aggregate_tables_dev --cqlversion=3.4.4 $CQL_URL_DEV"
alias cqlStage="cqlsh -u $CQL_USERNAME_STAGE -p '$CQL_PASSWORD_STAGE' -k ole_aggregate_tables_stage --cqlversion=3.4.4 $CQL_URL_STAGE"
alias cqlProd="cqlsh -u $CQL_USERNAME_PROD -p '$CQL_PASSWORD_PROD' -k ole_aggregate_tables_prod --cqlversion=3.4.4 $CQL_URL_PROD"

declare -a environments=("dev" "stage" "prod")
for i in "${environments[@]}"
do
   eval "function item_events_${i}() { cql_item_events $i \$* }"
   eval "function item_${i}() { cql_item $i \$* }"
   eval "function container_events_${i}() { cql_container_events $i \$* }"
   eval "function container_${i}() { cql_container $i \$* }"
   eval "function container_by_barcode_${i}() { cql_container_by_barcode $i \$* }"
done

function cql_container_events() {
    cql_script_$1 ole_events_$1 "select publish_time, event_type, data, event_id from container_events where container_id=$2"
}

function cql_item_events() {
    cql_script_$1 ole_events_$1 "select publish_time, event_type, data, event_id from item_events where item_id=$2"
}

function cql_item() {
    cql_script_$1 ole_aggregate_tables_$1 "select * from item_by_id where item_id=$2"
}

function cql_container() {
    cql_script_$1 ole_aggregate_tables_$1 "select * from container_by_id where container_id=$2"
    cql_script_$1 ole_aggregate_tables_$1 "select * from container_by_parent where location_id = '3844' and parent_id=$2"
}

function cql_container_by_barcode() {
    cql_script_$1 ole_aggregate_tables_$1 "select * from container_by_barcode where location_id = '3844' barcode=$2"
}

function cql_file_prod() {
    cqlFile $CQL_USERNAME_PROD $CQL_PASSWORD_PROD $1 $CQL_URL_PROD $2
}

function cql_file_stage() {
    cqlFile $CQL_USERNAME_STAGE $CQL_PASSWORD_STAGE $1 $CQL_URL_STAGE $2
}

function cql_file_dev() {
    cqlFile $CQL_USERNAME_DEV $CQL_PASSWORD_DEV $1 $CQL_URL_DEV $2
}

function cqlFile() {
    cqlsh -u $1 -p "$2" -k $3 --cqlversion=3.4.4 $4 -f $5
}

function cql_script_prod() {
    cqlScript $CQL_USERNAME_PROD $CQL_PASSWORD_PROD $1 $CQL_URL_PROD $2
}

function cql_script_stage() {
    cqlScript $CQL_USERNAME_STAGE $CQL_PASSWORD_STAGE $1 $CQL_URL_STAGE $2
}

function cql_script_dev() {
    cqlScript $CQL_USERNAME_DEV $CQL_PASSWORD_DEV $1 $CQL_URL_DEV $2
}

function cqlScript() {
    cqlsh -u $1 -p "$2" -k $3 --cqlversion=3.4.4 $4 -e $5
}

