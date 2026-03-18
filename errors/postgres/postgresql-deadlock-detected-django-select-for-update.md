# PostgreSQL deadlock detected with SELECT FOR UPDATE

> ERROR:  deadlock detected
> DETAIL:  Process 12345 waits for ShareLock on transaction 67890; blocked by process 12346.

## What happened
Two or more transactions tried to lock the same rows in different orders, creating a circular wait. PostgreSQL detected the deadlock and killed one of the transactions.

## Why it happens
When multiple transactions use `SELECT FOR UPDATE` (or Django's `select_for_update()`) on the same set of rows but in different orders, a deadlock can occur. For example, Transaction A locks row 1 then tries to lock row 2, while Transaction B locks row 2 then tries to lock row 1. Neither can proceed.

## How to fix it

Always lock rows in a consistent order (e.g., by primary key):
```python
# Django - always ORDER BY id to ensure consistent lock ordering
with transaction.atomic():
    accounts = Account.objects.filter(
        id__in=[account_a_id, account_b_id]
    ).order_by('id').select_for_update()

    for account in accounts:
        account.balance += amount
        account.save()
```

Use `nowait` or `skip_locked` to avoid blocking entirely:
```python
# Fail immediately if rows are already locked
accounts = Account.objects.select_for_update(nowait=True).filter(id=1)

# Skip rows that are already locked (useful for job queues)
jobs = Job.objects.select_for_update(skip_locked=True).filter(status='pending')[:10]
```

## Still not working?
- Check if you have triggers or foreign key constraints that acquire additional locks implicitly.
- Reduce transaction scope: keep transactions as short as possible, do not perform I/O or network calls inside a transaction.
- Use `SET lock_timeout = '5s';` to fail fast instead of waiting for the deadlock detector.
