## Root Cause
**A NullReferenceException occurs when you try to access a member (property, method, field) on an object reference that points to `null`** instead of an actual object instance.

## Common Scenarios

1. **Uninitialized variable**
   ```csharp
   MyClass obj;  // null by default
   obj.SomeMethod();  // ❌ NullReferenceException
   ```

2. **Method returning null**
   ```csharp
   var result = GetData();  // returns null
   result.Count;  // ❌ crashes
   ```

3. **Null collection item**
   ```csharp
   var items = GetList();
   items[0].Name;  // ❌ if items[0] is null
   ```

4. **Accessing on conditional result**
   ```csharp
   if (user.Profile != null)  // checks Profile
   {
       user.Profile.Avatar.Url;  // ❌ Avatar could still be null
   }
   ```

## How to Fix

**1. Instantiate before use**
```csharp
MyClass obj = new MyClass();  // ✅
obj.SomeMethod();
```

**2. Check for null**
```csharp
if (obj != null)
{
    obj.SomeMethod();
}
```

**3. Use null-coalescing operator**
```csharp
var name = user?.Name ?? "Unknown";  // ✅ safe navigation
```

**4. Use null-coalescing assignment** (C# 8+)
```csharp
obj ??= new MyClass();  // assigns only if null
```

**5. Validate method returns**
```csharp
var result = GetData();
if (result != null)
{
    DoSomething(result);
}
```

## Debug Strategy
1. **Enable "Break on All Exceptions"** in your debugger to catch exactly where it happens
2. **Check the stack trace** - it shows the exact line
3. **Add null checks** step-by-step up the chain (`user → user.Profile → user.Profile.Avatar`)

**The fix is always: ensure the object is initialized before accessing it, or check for null first.**
