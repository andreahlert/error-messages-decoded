# Elasticsearch circuit breaker tripped - data too large

> circuit_breaking_exception: [parent] Data too large, data for [<http_request>] would be [15687654400/14.6gb], which is larger than the limit

## What happened
Elasticsearch rejected a request because the estimated memory usage would exceed the circuit breaker threshold, which prevents the JVM from running out of heap memory.

## Why it happens
The parent circuit breaker (default 95% of JVM heap) was about to be exceeded. This is usually caused by fielddata loading for text fields, large aggregations, or too many buckets. It is a protective mechanism: without it, the node would crash with an OutOfMemoryError.

## How to fix it

Clear the fielddata cache to get immediate relief:
```bash
curl -X POST "localhost:9200/_cache/clear?fielddata=true"
```

Check what is consuming memory:
```bash
curl -s "localhost:9200/_nodes/stats/breaker" | jq '.nodes[].breakers'
```

Use `doc_values` (default for keyword fields) instead of fielddata for text fields:
```bash
# Change text fields to keyword where you need sorting/aggregations
curl -X PUT "localhost:9200/myindex/_mapping" -H 'Content-Type: application/json' -d '{
  "properties": {
    "status": { "type": "keyword" }
  }
}'
```

If you must aggregate on text fields, use a multi-field mapping with a keyword sub-field:
```json
{
  "properties": {
    "description": {
      "type": "text",
      "fields": {
        "raw": { "type": "keyword" }
      }
    }
  }
}
```

Adjust the breaker limits if you have confirmed the node has headroom:
```bash
curl -X PUT "localhost:9200/_cluster/settings" -H 'Content-Type: application/json' -d '{
  "persistent": {
    "indices.breaker.fielddata.limit": "40%",
    "indices.breaker.request.limit": "40%"
  }
}'
```

## Still not working?
- Reduce the number of aggregation buckets or use composite aggregations for pagination.
- Avoid loading `fielddata: true` on high-cardinality text fields as they consume enormous memory.
- Review your mapping: fields used only for filtering/aggregation should be `keyword` type, not `text`.
