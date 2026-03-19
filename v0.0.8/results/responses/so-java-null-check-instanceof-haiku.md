# Root Cause

In Java, the `instanceof` operator **safely returns `false` when called on `null`** without throwing an exception. Therefore, a null check before `instanceof` is redundant.

```java
// Redundant - unnecessary null check
if (obj != null && obj instanceof String) {
    // ...
}

// Correct - instanceof handles null safely
if (obj instanceof String) {
    // ...
}
```

When `obj` is `null`, `instanceof` simply returns `false`, allowing the condition to fail gracefully.

# How to Fix

**Remove the null check entirely:**

```java
// Before (with unnecessary null check)
if (value != null && value instanceof User) {
    User user = (User) value;
    // ...
}

// After (null check removed)
if (value instanceof User) {
    User user = (User) value;
    // ...
}
```

# Why Linters Flag This

Code analysis tools flag this pattern because:
1. It's unnecessary boilerplate that clutters the code
2. It suggests misunderstanding of how `instanceof` works
3. Modern Java (16+) supports pattern matching, which makes this even more concise:

```java
if (value instanceof User user) {
    // user is automatically cast here
}
```

---

**Note:** Is this error appearing in your project? If you share the specific file/line, I can help you apply the fix directly.
