## Root Cause

Java's functional interfaces (`Function`, `Consumer`, `Supplier`, etc.) used in streams don't declare **any** checked exceptions in their method signatures. When a lambda implements these interfaces, it cannot throw checked exceptions — they must be either caught or declared in the interface method signature, which it isn't.

```java
// This won't compile — Function doesn't declare IOException
list.stream()
    .map(item -> readFile(item))  // readFile throws IOException
    .collect(toList());
```

## Solutions

### 1. **Wrap in unchecked exception** (most common)
Catch the checked exception and throw as `RuntimeException`:

```java
list.stream()
    .map(item -> {
        try {
            return readFile(item);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    })
    .collect(toList());
```

### 2. **Custom functional interface** (cleanest for reuse)
Create a functional interface that declares checked exceptions:

```java
@FunctionalInterface
interface CheckedFunction<T, R> {
    R apply(T t) throws Exception;
}

// Adapter to use with streams
static <T, R> Function<T, R> unchecked(CheckedFunction<T, R> f) {
    return t -> {
        try {
            return f.apply(t);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    };
}

// Use it
list.stream()
    .map(unchecked(item -> readFile(item)))
    .collect(toList());
```

### 3. **Extract to a method** (avoids lambda altogether)
Move the risky code outside the stream:

```java
List<String> results = new ArrayList<>();
for (String item : list) {
    try {
        results.add(readFile(item));
    } catch (IOException e) {
        // handle
    }
}
```

### 4. **Use third-party libraries**
Libraries like [Vavr](https://www.vavr.io/) or [Jool](https://www.jooq.org/products/jool) provide checked exception-aware streams.

**Recommendation**: Use solution #2 (custom wrapper) if you'll use this pattern multiple times, otherwise solution #1 for quick fixes.
