#! /bin/sh

while true; do
  if curl -s "http://elasticsearch:9200/_cat/indices?v" | grep -q fluentd; then
    break
  else
    sleep 1
 fi
done

while true; do
  if curl -o /dev/null --stderr /dev/null -f -s -L "http://kibana:5601/status"; then
    break
  else
    sleep 1
  fi
done

index_pattern="fluentd-*"
id="fluentd-*"
time_field="@timestamp"
curl -f -XPOST -H "Content-Type: application/json" -H "kbn-xsrf: anything" \
  "http://kibana:5601/api/saved_objects/index-pattern/$id" \
  -d"{\"attributes\":{\"title\":\"$index_pattern\",\"timeFieldName\":\"$time_field\"}}"
# Make it the default index
curl -XPOST -H "Content-Type: application/json" -H "kbn-xsrf: anything" \
  "http://kibana:5601/api/kibana/settings/defaultIndex" \
  -d"{\"value\":\"$id\"}"
