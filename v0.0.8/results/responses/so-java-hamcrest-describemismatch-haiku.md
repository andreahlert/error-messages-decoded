# Root Cause

You have **multiple versions of Hamcrest on your classpath**, and an older version (pre-1.1) is being loaded at runtime. The `describeMismatch()` method was added in Hamcrest 1.1, so if an older version loads first, you get `NoSuchMethodError`.

This typically happens because:
- JUnit bundles an old Hamcrest version that gets loaded before your newer one
- A test framework (Mockito, TestNG) depends on an older Hamcrest
- Maven/Gradle dependency resolution picks the wrong version

# Fix

**For Maven:**

Add this to your `<dependencies>` to explicitly use a modern Hamcrest and exclude older bundled versions:

```xml
<!-- Explicitly declare recent Hamcrest FIRST -->
<dependency>
    <groupId>org.hamcrest</groupId>
    <artifactId>hamcrest</artifactId>
    <version>2.2</version>
    <scope>test</scope>
</dependency>

<!-- Exclude old Hamcrest from JUnit -->
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13.2</version>
    <scope>test</scope>
    <exclusions>
        <exclusion>
            <groupId>org.hamcrest</groupId>
            <artifactId>hamcrest-core</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

**For Gradle:**

```gradle
testImplementation('junit:junit:4.13.2') {
    exclude group: 'org.hamcrest', module: 'hamcrest-core'
}
testImplementation 'org.hamcrest:hamcrest:2.2'
```

**Verify:** Run `mvn dependency:tree | grep hamcrest` (Maven) or `gradle dependencies | grep hamcrest` (Gradle) to confirm only one version appears.

**In IntelliJ:** After changing dependencies, go to **File → Invalidate Caches → Invalidate and Restart** to clear the cached classpath.
