# Root Cause

ASP.NET's `JavaScriptSerializer` has a default `maxJsonLength` limit of ~102,400 bytes (100 KB) to prevent DOS attacks. When you serialize/deserialize JSON larger than this limit, it throws an exception.

# Specific Fixes

## Option 1: web.config (ASP.NET Framework)

```xml
<configuration>
  <system.web.extensions>
    <scripting>
      <webServices>
        <jsonSerialization maxJsonLength="2147483647" />
      </webServices>
    </scripting>
  </system.web.extensions>
</configuration>
```

The max value is 2,147,483,647 bytes (~2 GB).

## Option 2: Programmatically (when you control serialization)

```csharp
var serializer = new JavaScriptSerializer();
serializer.MaxJsonLength = int.MaxValue;
var json = serializer.Serialize(yourObject);
```

## Option 3: ASP.NET Core

If you're on ASP.NET Core, the issue is usually with `System.Text.Json`, which has no hard limit by default. But if you need to set one:

```csharp
var options = new JsonSerializerOptions 
{ 
    MaxDepth = int.MaxValue // Not the same as length, but controls recursion
};
```

# ⚠️ Important

**Unlimited length is a security risk.** Before setting it to max:

1. **Validate input size** - Check the actual JSON size you need to support
2. **Use a reasonable limit** - Set it to something like 50 MB (52,428,800) instead of unlimited
3. **Stream large files** - For really large JSON, use streaming parsers instead of loading into memory
4. **Check your actual need** - If you're regularly serializing 100+ MB of JSON, your architecture may need rethinking

The default 100 KB limit exists for a reason. If you're hitting it frequently, that's a sign to review what you're serializing.
