# MongoDB E11000 duplicate key error on _id

> E11000 duplicate key error collection: mydb.mycollection index: _id_ dup key: { _id: ObjectId('507f1f77bcf86cd799439011')

## What happened
MongoDB rejected an insert because a document with the same `_id` already exists in the collection.

## Why it happens
This commonly happens when a write operation is retried after a network error. The first write may have succeeded on the server but the acknowledgment was lost, so the client retries with the same `_id` (same ObjectId). It can also occur when manually setting `_id` values or when importing data that contains duplicate identifiers.

## How to fix it

If this is caused by network retries, handle the duplicate key error gracefully:
```python
from pymongo.errors import DuplicateKeyError

try:
    collection.insert_one({"_id": my_id, "data": "value"})
except DuplicateKeyError:
    # The document was already inserted by the previous attempt
    pass
```

Use `update_one` with `upsert=True` for idempotent writes:
```python
collection.update_one(
    {"_id": my_id},
    {"$set": {"data": "value"}},
    upsert=True
)
```

Enable retryable writes in the connection string (MongoDB 3.6+):
```python
client = MongoClient("mongodb://host:27017/?retryWrites=true&w=majority")
```

## Still not working?
- If importing data, check for duplicate `_id` values: `db.collection.aggregate([{$group: {_id: "$_id", count: {$sum: 1}}}, {$match: {count: {$gt: 1}}}])`.
- If using a custom ObjectId generation scheme, ensure uniqueness across all application instances.
- Check your write concern settings: with `w=0` (unacknowledged), you will not get errors back but duplicates can still occur server-side.
