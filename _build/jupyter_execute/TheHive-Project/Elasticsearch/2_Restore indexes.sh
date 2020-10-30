ES_HOST="http://localhost:9200"

curl -s  ''${ES_HOST}'/_cat/indices?v'

THEHIVE_INDEX="the_hive_15"
CORTEX_INDEX="cortex_4"

SNAPSHOT_PATH="the_hive_backup"
BACKUP_FOLDER="."


SNAPSHOT_PATH="the_hive_backup"


curl -s -XPUT ''${ES_HOST}'/_snapshot/'${SNAPSHOT_PATH}'' -H 'Content-Type: application/json' -d '{
    "type": "fs",
    "settings": {
        "location": "'${BACKUP_FOLDER}'",
        "compress": true
    }
}' | jq

curl -s -XGET  -H ' Content-Type: application/json' ''${ES_HOST}'/_cat/snapshots/'${SNAPSHOT_PATH}''

THEHIVE_BACKUP_NAME="thehive_20201027-2"


curl -s -XPOST  -H 'Content-Type: application/json' \
''${ES_HOST}'/_snapshot/'${SNAPSHOT_PATH}'/'${THEHIVE_BACKUP_NAME}'/_restore' -d '{ 
"indices":"'"$THEHIVE_INDEX"'"
}' | jq

curl -s ${ES_HOST}/_cat/indices\?v

BACKUP_FOLDER="."
CORTEX_SNAPSHOT_PATH="the_hive_backup"

curl -s -XPUT ''${ES_HOST}'/_snapshot/'${CORTEX_SNAPSHOT_PATH}'' -H 'Content-Type: application/json' -d '{
    "type": "fs",
    "settings": {
        "location": "'${BACKUP_FOLDER}'",
        "compress": true
    }
}' | jq

curl -s -XGET  -H' Content-Type: application/json' ''${ES_HOST}'/_cat/snapshots/'${CORTEX_SNAPSHOT_PATH}''

CORTEX_BACKUP_NAME="cortex_20201027-2"

curl -s -XPOST  -H 'Content-Type: application/json' \
''${ES_HOST}'/_snapshot/'${CORTEX_SNAPSHOT_PATH}'/'${CORTEX_BACKUP_NAME}'/_restore' -d '{
"indices":"'${CORTEX_INDEX}'"
}' | jq

curl -s ${ES_HOST}/_cat/indices\?v
