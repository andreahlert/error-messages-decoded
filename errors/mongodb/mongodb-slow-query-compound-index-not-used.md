# MongoDB COLLSCAN on query with compound index not used

> COLLSCAN detected in slow query log: { status: 'active', createdAt: { $gte: ISODate('2024-01-01') }, category: 'premium' }

## What happened
MongoDB performed a full collection scan instead of using an index for a query that filters on multiple fields. The existing compound index is not being used.

## Why it happens
MongoDB compound indexes follow the ESR (Equality, Sort, Range) rule and require that queries match the index prefix. If your index is `{category: 1, createdAt: 1, status: 1}` but your query filters on `status` first, the index prefix does not match. The order of fields in the compound index matters: equality fields must come first, then sort fields, then range fields.

## How to fix it

Check how the query is being executed:
```javascript
db.collection.find({
  status: 'active',
  createdAt: { $gte: ISODate('2024-01-01') },
  category: 'premium'
}).explain('executionStats')
```

Create the compound index following the ESR rule (Equality, Sort, Range):
```javascript
// Equality fields first (status, category), then range field (createdAt)
db.collection.createIndex({ status: 1, category: 1, createdAt: 1 })
```

The index field order must match the query pattern:
```javascript
// If your query is:
// { status: 'active', category: 'premium', createdAt: { $gte: ... } }
// The index prefix must start with the equality fields:
// { status: 1, category: 1, createdAt: 1 }  ← correct
// { createdAt: 1, status: 1, category: 1 }   ← wrong, range field first
```

## Still not working?
- Run `explain('allPlansExecution')` to see why MongoDB chose COLLSCAN over the index.
- If the query returns more than ~30% of the collection, MongoDB may correctly prefer a COLLSCAN.
- Check index size with `db.collection.stats()`. If the index does not fit in RAM, performance degrades.
- Use `hint()` to force a specific index and compare performance: `db.collection.find(query).hint({status: 1, category: 1, createdAt: 1})`.
