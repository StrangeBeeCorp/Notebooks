ES_HOST="http://localhost:9200"

curl -s ${ES_HOST}/_cat/indices\?v

THEHIVE_INDEX="the_hive_15"
CORTEX_INDEX="cortex_4"

SNAPSHOT_PATH="the_hive_backup"
BACKUP_FOLDER="/opt/backup"


curl -XPUT  -H 'Content-Type: application/json' ''${ES_HOST}'/_snapshot/'${SNAPSHOT_PATH}'' -d '{
    "type": "fs",
    "settings": {
        "location": "'${BACKUP_FOLDER}'",
        "compress": true
    }}' | jq

curl -XGET  -H' Content-Type: application/json' ''${ES_HOST}'/_cat/snapshots/'${SNAPSHOT_PATH}''

THEHIVE_SNAPSHOT="thehive_202010230-1"

curl -XPUT  -H 'Content-Type: application/json' ''${ES_HOST}'/_snapshot/'${SNAPSHOT_PATH}/${THEHIVE_SNAPSHOT}'?wait_for_completion=true' -d '{
    "indices":"'"$THEHIVE_INDEX"'"
    }'| jq

curl -s -XGET  -H' Content-Type: application/json' ''${ES_HOST}'/_cat/snapshots/'${SNAPSHOT_PATH}''

CORTEX_SNAPSHOT="cortex_202010230-1"

curl -XPUT  -H 'Content-Type: application/json' ''${ES_HOST}'/_snapshot/'${SNAPSHOT_PATH}/${CORTEX_SNAPSHOT}'?wait_for_completion=true' -d '{
    "indices":"'"$CORTEX_INDEX"'"
    }'| jq

curl -s -XGET  -H' Content-Type: application/json' ''${ES_HOST}'/_cat/snapshots/'${SNAPSHOT_PATH}''

curl -s ${ES_HOST}/_cat/indices\?v
