# @Autowired Field is Null: Root Causes & Fixes

## Root Cause

Spring can't autowire a field when:

1. **The bean is never registered** — The class doesn't exist in the Spring context. Missing `@Component`, `@Service`, `@Repository`, or not configured in `@ComponentScan`.

2. **You're instantiating manually** — Creating the object with `new MyClass()` bypasses Spring entirely. Spring only injects into objects it creates.

3. **Injection point is wrong** — You're accessing the field in a constructor or in a static initializer before Spring has finished injection. Dependency injection happens after construction.

4. **The dependency isn't in the context** — The bean you're trying to inject doesn't exist or isn't configured as a Spring bean.

5. **Wrong scope** — Injecting a shorter-lived bean (e.g., prototype) into a longer-lived one (e.g., singleton) can cause visibility issues.

## How to Fix

**Verify the bean is registered:**
```java
@Service  // Add this if missing
public class MyService {
    // ...
}
```

**Never instantiate with `new` if it needs injection:**
```java
// Wrong
MyService service = new MyService();

// Right: let Spring create it
@Autowired
private MyService service;
```

**Don't access injected fields in constructor:**
```java
// Wrong
public MyController(@Autowired MyService service) {
    this.myField = service;  // null
}

// Right: use constructor injection or setter injection
public MyController(MyService service) {
    this.myField = service;  // works
}
```

**Verify dependency exists:**
```java
// Make sure the dependency is also a @Component/@Service
@Service
public class MyService {
    
    @Autowired
    private SomeDependency dep;  // SomeDependency must be @Component
}
```

**Check `@ComponentScan` basePackages:**
```java
@SpringBootApplication  // scans everything by default
// or
@ComponentScan(basePackages = "com.myapp.services")  // limit scope carefully
```

Use constructor injection over field injection whenever possible — it makes dependencies explicit and testable.
