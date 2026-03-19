# NullReferenceException in C#

## Root Cause
A **NullReferenceException** occurs when you try to access a member (method, property, indexer) on an object that is `null`. The object reference doesn't exist, so there's nothing to access.

```csharp
string text = null;
int length = text.Length;  // NullReferenceException here
```

## How to Fix It

**1. Check before using**
```csharp
string text = null;
if (text != null)
{
    int length = text.Length;
}
```

**2. Use null-coalescing operator (`??`)**
```csharp
int length = text?.Length ?? 0;  // Returns 0 if text is null
```

**3. Use null-conditional operator (`?.`)**
```csharp
int length = text?.Length;  // Returns null if text is null, otherwise the length
```

**4. Initialize your variables**
```csharp
string text = ""; // Not null
int length = text.Length;  // Works fine
```

**5. Guard clauses (early return)**
```csharp
public void ProcessText(string text)
{
    if (text == null)
        return;
    
    // Safe to use text here
}
```

## Finding the Source

The stack trace shows you exactly which line triggered it. Look for:
- Uninitialized variables
- Methods returning `null` when you don't expect it
- Collections/properties that haven't been populated
- Null parameters passed to methods

Enable **nullability checks** (C# 8.0+) in your `.csproj`:
```xml
<PropertyGroup>
    <Nullable>enable</Nullable>
</PropertyGroup>
```

This makes the compiler warn about potential null issues at build time instead of runtime.
