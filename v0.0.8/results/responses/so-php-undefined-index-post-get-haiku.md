## Root Cause

You're accessing a key in `$_POST` or `$_GET` that doesn't exist. This happens when:
- A form field wasn't submitted
- A query parameter is missing from the URL
- The key name is misspelled
- The field exists in your code but not in the actual request

PHP throws a notice because it's trying to read a non-existent array index.

## How to Fix

**Option 1: Check before accessing (most explicit)**
```php
if (isset($_POST['fieldname'])) {
    $value = $_POST['fieldname'];
} else {
    $value = '';  // or some default
}
```

**Option 2: Null coalescing operator (PHP 7+, recommended)**
```php
$value = $_POST['fieldname'] ?? '';
```

**Option 3: Nested null coalescing for default**
```php
$value = $_POST['fieldname'] ?? $_GET['fieldname'] ?? 'default';
```

**Option 4: array_key_exists() if you need to distinguish between missing and null**
```php
if (array_key_exists('fieldname', $_POST)) {
    $value = $_POST['fieldname'];
}
```

**Option 5: Null safe operator (PHP 8+)**
```php
$value = $_POST['fieldname']?->method() ?? 'default';  // for objects only
```

## Best Practice

Use **null coalescing (`??`)** for most cases. It's concise, readable, and handles the common scenario where you want a default if the key is missing.

For critical security-sensitive data, pair it with validation:
```php
$email = $_POST['email'] ?? '';
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    // handle invalid email
}
```

Don't suppress the notice with `@` or lowering error reporting—that masks real problems. Fix the root cause instead.
