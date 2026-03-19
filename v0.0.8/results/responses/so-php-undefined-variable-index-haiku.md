## Root Cause

**Notice: Undefined variable** and **Warning: Undefined array key** occur when you reference a variable or array element that hasn't been defined or initialized yet.

## Common Scenarios & Fixes

### 1. **Using a variable before declaring it**
```php
// ❌ Wrong
echo $name; // Notice: Undefined variable: name

// ✅ Fix: Initialize first
$name = "John";
echo $name;

// ✅ Or check if it exists
echo isset($name) ? $name : "Unknown";
```

### 2. **Accessing array keys that don't exist**
```php
// ❌ Wrong
$user = ["id" => 1];
echo $user["name"]; // Warning: Undefined array key: name

// ✅ Fix 1: Check before access
if (isset($user["name"])) {
    echo $user["name"];
}

// ✅ Fix 2: Use null coalescing (PHP 7+)
echo $user["name"] ?? "Default value";

// ✅ Fix 3: Use null-safe operator (PHP 8+)
echo $user["name"] ?-> strtoupper(); // Returns null if key missing
```

### 3. **From form/request data**
```php
// ❌ Wrong
echo $_GET["search"]; // Warning if key doesn't exist

// ✅ Fix
echo $_GET["search"] ?? ""; // Returns empty string if missing
```

### 4. **Loop variables**
```php
// ❌ Wrong
if ($count > 0) { $total += $count; } // Notice if $total undefined

// ✅ Fix: Initialize before use
$total = 0;
if ($count > 0) { $total += $count; }
```

## Error Reporting Configuration

If notices are hidden but you want to catch them:

```php
// Show all errors (for development)
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Hide notices in production
error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING);
```

## Key Takeaway

Always **initialize variables before use** and **check if array keys exist** before accessing them. This prevents errors and makes code more robust.
