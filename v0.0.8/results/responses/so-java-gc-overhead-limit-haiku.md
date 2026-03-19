## Root Cause

The **GC overhead limit exceeded** error means your JVM is spending >98% of its time on garbage collection but only freeing <2% of heap memory in return. This happens when:

1. **Heap too small** for your workload — the JVM keeps thrashing trying to make space
2. **Memory leak** — objects accumulating faster than GC can clean them
3. **Inefficient algorithms** — creating excessive temporary objects

## How to Fix

### 1. Increase Heap Size (First Try)
```bash
java -Xmx4g -Xms4g YourApp
```
- `-Xmx` sets max heap (adjust to your system, e.g., 4g, 8g)
- `-Xms` sets initial heap (match Xmx to avoid resize overhead)

If this fixes it, your original heap was just too small.

### 2. Find the Memory Leak
If increasing heap doesn't help, you have a leak. Capture a heap dump:

```bash
java -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp YourApp
```

Then analyze with **Eclipse Memory Analyzer** or **JProfiler**:
- Look for objects holding references they shouldn't
- Check for collections (Lists, Maps) growing unboundedly
- Look for static collections accumulating data

### 3. Disable the GC Limit (Last Resort)
```bash
java -XX:-UseGCOverheadLimit YourApp
```
This suppresses the error but **doesn't fix the problem** — it'll eventually hit OutOfMemoryError. Only use for testing.

### 4. Profile with JProfiler or YourKit
Run with a profiler to see which objects are allocating memory:
- Identify hot paths creating garbage
- Replace inefficient collections
- Add object pooling if creating millions of short-lived objects

## Quick Checklist
- [ ] Increase `-Xmx` to match your available RAM
- [ ] Check for unclosed resources (streams, connections, file handles)
- [ ] Look for infinite loops or recursive calls building lists
- [ ] Capture heap dump and analyze for leak culprits

**Start with heap size.** If that doesn't work, you have a leak that needs debugging.
