## Root Cause

Entity Framework keeps a single connection open and active. When you execute a query, it opens a **DataReader** to fetch results. If you try to run *another* query on the same connection before that DataReader closes, you get this error.

This typically happens when:

1. **Querying inside a foreach loop** on results from another query (the first DataReader is still open)
2. **Lazy loading** triggered during iteration (tries to load related entities while reading parent results)
3. **Multiple sequential queries** without fully materializing the first one

## Solutions

### Solution 1: Materialize with `ToList()` (Most Common)
Call `ToList()` on your first query to fetch all results into memory, closing the DataReader:

```csharp
// WRONG - DataReader still open when inner query executes
var users = context.Users.Where(u => u.Active);
foreach (var user in users) // <- DataReader open here
{
    var orders = context.Orders.Where(o => o.UserId == user.Id); // <- ERROR
}

// CORRECT - Materialize first query
var users = context.Users.Where(u => u.Active).ToList(); // <- DataReader closed
foreach (var user in users)
{
    var orders = context.Orders.Where(o => o.UserId == user.Id).ToList();
}
```

### Solution 2: Eager Load with `Include()` (Best Practice)
Load related data upfront instead of lazy loading:

```csharp
// Instead of separate queries, use Include
var users = context.Users
    .Where(u => u.Active)
    .Include(u => u.Orders) // Load orders with users in one query
    .ToList();

foreach (var user in users)
{
    var orders = user.Orders; // No second query needed
}
```

### Solution 3: Enable MARS (SQL Server Only)
Add `MultipleActiveResultSets=true` to your connection string to allow multiple open DataReaders:

```
Server=myserver;Database=mydb;MultipleActiveResultSets=true;
```

**Warning:** MARS is a band-aid that can hide inefficient query patterns. Prefer Solutions 1-2.

### Solution 4: Separate DbContext Instances
Use different DbContext instances for concurrent queries:

```csharp
var users = context.Users.Where(u => u.Active).ToList();

using (var context2 = new MyDbContext())
{
    foreach (var user in users)
    {
        var orders = context2.Orders.Where(o => o.UserId == user.Id).ToList();
    }
}
```

**Quick fix:** Try **Solution 1** (`.ToList()`) first. For cleaner code, refactor to **Solution 2** (`.Include()`).
