ES_HOST='http://localhost:9200'

curl -s ''${ES_HOST}'/_cat/indices?v'

THEHIVE_INDEX="the_hive_15"
CORTEX_INDEX="cortex_4"
NEW_THEHIVE_INDEX="new_the_hive_15"
NEW_CORTEX_INDEX="new_cortex_4"

curl -s ''${ES_HOST}/${THEHIVE_INDEX}'?human' | jq '.'${THEHIVE_INDEX}'.settings.index.version.created_string'

curl -s -XPUT ''${ES_HOST}'/'${NEW_THEHIVE_INDEX}'' \
  -H 'Content-Type: application/json' \
  -d "$(curl -s ${ES_HOST}/${THEHIVE_INDEX} |\
   jq '.'${THEHIVE_INDEX}'|
   del(.settings.index.provided_name,
    .settings.index.creation_date,
    .settings.index.uuid,
    .settings.index.version,
    .settings.index.mapping.single_type,
    .mappings.doc._all)'
    )" | jq

curl -s ${ES_HOST}/_cat/indices\?v

curl -s -XPOST -H 'Content-Type: application/json' ${ES_HOST}/_reindex -d '{
  "conflicts": "proceed",
  "source": {
    "index": "'${THEHIVE_INDEX}'"
  },
  "dest": {
    "index": "'${NEW_THEHIVE_INDEX}'"
  }
}' | jq

curl -s ${ES_HOST}/_cat/indices\?v

curl -s -XDELETE ${ES_HOST}/$THEHIVE_INDEX | jq

curl -s -XPOST -H 'Content-Type: application/json'  ''${ES_HOST}'/_aliases' -d '{
    "actions": [
        {
            "add": {
                "index": "'${NEW_THEHIVE_INDEX}'",
                "alias": "'${THEHIVE_INDEX}'"
            }
        }
    ]
}' | jq

curl -s -XGET ${ES_HOST}/_alias?pretty 

curl -s ''${ES_HOST}/${THEHIVE_INDEX}'?human' | jq '.'${NEW_THEHIVE_INDEX}'.settings.index.version.created_string'

curl -s ''${ES_HOST}/${CORTEX_INDEX}'?human' | jq '.'${CORTEX_INDEX}'.settings.index.version.created_string'

curl -s -XPUT ''${ES_HOST}/${NEW_CORTEX_INDEX}'' \
  -H 'Content-Type: application/json' \
  -d "$(curl -s ${ES_HOST}/${CORTEX_INDEX} |\
   jq '.'${CORTEX_INDEX}' |
   del(.settings.index.provided_name,
    .settings.index.creation_date,
    .settings.index.uuid,
    .settings.index.version,
    .settings.index.mapping.single_type,
    .mappings.doc._all)'
    )" | jq

curl -s ''${ES_HOST}'/_cat/indices?v'

curl -s -XPOST -H 'Content-Type: application/json' ${ES_HOST}/_reindex -d '{
  "conflicts": "proceed",
  "source": {
    "index": "'${CORTEX_INDEX}'"
  },
  "dest": {
    "index": "'${NEW_CORTEX_INDEX}'"
  }
}' | jq

curl -s ''${ES_HOST}'/_cat/indices?v'

curl -s -XDELETE ${ES_HOST}/$CORTEX_INDEX | jq

curl -s -XPOST -H 'Content-Type: application/json'  ''${ES_HOST}'/_aliases' -d '{
    "actions": [
        {
            "add": {
                "index": "'${NEW_CORTEX_INDEX}'",
                "alias": "'${CORTEX_INDEX}'"
            }
        }
    ]
}' | jq

curl -s -XGET ${ES_HOST}/_alias?pretty 

curl -s ''${ES_HOST}/${CORTEX_INDEX}'?human' | jq '.'${NEW_CORTEX_INDEX}'.settings.index.version.created_string'
