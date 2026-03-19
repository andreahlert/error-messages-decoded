# NoSuchMethodError: Root Cause & Fix

## Root Cause
`NoSuchMethodError` happens at **runtime** when the JVM tries to call a method that doesn't exist in the actual class loaded in memory. This is almost always a **classpath/dependency version mismatch**:

1. **You compiled against Library Version A** (which has `method()`)
2. **You run with Library Version B** (which doesn't have `method()`)

Common scenarios:
- Dependency downgraded or removed a method in a patch/minor version
- Wrong JAR file on classpath (old/new version)
- Transitive dependency conflict (two versions of same lib loaded)
- Deserializing old objects with changed methods

## How to Fix (Specific Steps)

### 1. **Identify the problematic method**
Look at your stack trace carefully. It shows which class/method is missing:
```
java.lang.NoSuchMethodError: com.example.MyClass.myMethod()
```

### 2. **Check your dependency versions**
```bash
# Maven: see what's actually loaded
mvn dependency:tree | grep problematic-lib

# Gradle: check build output for conflicts
./gradlew dependencies
```

### 3. **Verify method exists in current version**
```bash
# Inspect the JAR directly
javap -classpath your-lib.jar com.example.MyClass

# Or check the library's source/docs for what version introduced/removed it
```

### 4. **Fix the mismatch**
- **Update dependencies** to a version that has the method:
  ```xml
  <!-- Maven: explicit version that has the method -->
  <dependency>
    <groupId>com.example</groupId>
    <artifactId>my-lib</artifactId>
    <version>2.5.0</version>  <!-- Ensure this version has the method -->
  </dependency>
  ```

- **Exclude conflicting transitive dependencies**:
  ```xml
  <dependency>
    <groupId>A</groupId>
    <artifactId>uses-lib</artifactId>
    <exclusions>
      <exclusion>
        <groupId>com.example</groupId>
        <artifactId>my-lib</artifactId>
      </exclusion>
    </exclusions>
  </dependency>
  ```

- **Lock to compatible versions**: Use dependency management to ensure all paths use the same library version.

### 5. **Clean rebuild**
```bash
mvn clean install  # Maven
./gradlew clean build  # Gradle
```

## Quick Diagnosis
If you're unsure which dependency changed, check recent updates:
```bash
git log -p pom.xml  # or build.gradle
# Look for version changes in the last commits
```

**TL;DR**: Your compiled code expects a method that's not in the runtime JAR. Update the dependency to a version that has it, or exclude conflicting transitive versions.
