# NoClassDefFoundError vs ClassNotFoundException

## Root Causes

**ClassNotFoundException** (checked exception):
- Thrown when trying to load a class **at runtime** via reflection that doesn't exist
- E.g., `Class.forName("com.example.NonExistent")`, `Class.forName().newInstance()`, `ClassLoader.loadClass()`
- You explicitly asked for the class to be loaded and it wasn't found

**NoClassDefFoundError** (error, not exception):
- Thrown when a class **was compiled against** but is missing at runtime
- E.g., you compiled `MyApp.java` against `LibraryA.jar`, but removed that jar before running
- The JVM tried to initialize a class during execution and discovered a dependency class was missing
- Often a **classpath/version mismatch** problem

## Key Differences

| Aspect | ClassNotFoundException | NoClassDefFoundError |
|--------|----------------------|----------------------|
| **Type** | Checked Exception (extends `Exception`) | Error (extends `Throwable`) |
| **When thrown** | Explicit runtime class loading (reflection) | Implicit class initialization during execution |
| **Root cause** | Class doesn't exist on classpath | Class existed at compile-time but missing at runtime |
| **Recovery** | Can catch and handle gracefully | Rarely recoverable; indicates deployment issue |

## How to Fix

**For ClassNotFoundException:**
- Check spelling of class name
- Verify the jar/package is on the classpath
- Catch and provide fallback logic if class is optional

```java
try {
    Class.forName("com.example.SomeClass");
} catch (ClassNotFoundException e) {
    // Handle missing optional class
}
```

**For NoClassDefFoundError:**
- Verify all runtime dependencies are present (check `java -cp` or jar manifests)
- Ensure version compatibility between compiled code and runtime jars
- Check for removed/deleted jar files in deployment
- Clean rebuild and redeploy

Both ultimately mean: **the class isn't where the JVM expects it**. The distinction is whether you asked for it explicitly (ClassNotFoundException) or the JVM discovered it was missing during normal execution (NoClassDefFoundError).
