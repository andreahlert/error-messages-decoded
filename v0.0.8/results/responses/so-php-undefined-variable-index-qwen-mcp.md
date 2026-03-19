The errors you're encountering, "Undefined variable," "Undefined index," and "Undefined array key," are all related to issues where PHP cannot find or access variables, keys in arrays, or indices within arrays that were expected but not defined.

### Root Cause:

1. **Undefined Variable:**
   - This error occurs when a variable is used before it has been declared.
     ```php
     $variable = "Hello";
     echo $variable; // Undefined variable error
     ```
   - To fix this, ensure all variables are properly initialized and assigned values.

2. **Undefined Index:**
   - This happens when trying to access an index in an array that does not exist.
     ```php
     $array = [1 => "one", 2 => "two"];
     echo $array[3]; // Undefined index error
     ```
   - To fix this, check the keys of your arrays and ensure they match those used for accessing elements.

3. **Undefined Array Key:**
   - This occurs when trying to access a key that does not exist in an associative array.
     ```php
     $assocArray = ["key1" => "value1", "key2" => "value2"];
     echo $assocArray["key3"]; // Undefined array key error
     ```
   - To fix this, ensure the keys you are trying to access actually exist in your arrays.

### How to Fix It:

#### 1. Check Variable Declarations:
Ensure that all variables used in your script have been properly declared and initialized before they are accessed or used.

```php
$variable = "Hello";
echo $variable; // This will work fine now.
```

#### 2. Verify Array Keys:
Make sure the keys you are trying to access exist in the arrays you are using.

```php
$array = [1 => "one", 2 => "two"];
echo $array[3]; // This will throw an error because key 3 does not exist.
```

#### 3. Check for Missing Keys:
If you're working with associative arrays, ensure that all keys you are trying to access actually exist.

```php
$assocArray = ["key1" => "value1", "key2" => "value2"];
echo $assocArray["key3"]; // This will throw an error because key 3 does not exist.
```

#### 4. Use Conditional Checks:
Before accessing array elements or variables, check if they are defined.

```php
$variable = isset($variable) ? $variable : "Default Value";
echo $variable; // This ensures the variable is set before being accessed.
```

### Additional Tips:

- **Use `isset()` and `empty()`:** These functions can help you determine whether a variable or array key exists without throwing errors.
  ```php
  if (isset($array['key'])) {
      echo $array['key'];
  }
  ```

- **Check for Duplicates:** Ensure that your arrays do not contain duplicate keys, as this can also cause issues.

```php
$assocArray = ["key1" => "value1", "key2" => "value2"];
if (isset($assocArray["key1"]) && isset($assocArray["key2"])) {
    echo "Both key1 and key2 exist.";
} else {
    echo "One of the keys does not exist.";
}
```

By following these steps, you should be able to resolve the notices and warnings related to undefined variables, indices, and array keys in your PHP scripts.
