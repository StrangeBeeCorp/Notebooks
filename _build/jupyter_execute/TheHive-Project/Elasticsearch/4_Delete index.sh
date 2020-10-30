ES_HOST="http://localhost:9200"
INDEX="new_the_hive_15"

curl -s -XDELETE ${ES_HOST}/${INDEX}
