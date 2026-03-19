# Root Cause

When you create a `Date` object with invalid input (bad string format, NaN, undefined, etc.), JavaScript **doesn't throw an error**. Instead, it silently creates a Date object with an internal time value of `NaN`. The Date object still exists and methods like `toString()` return `"Invalid Date"`, but you can't detect it by just checking `if (date)` since the object is truthy.

# How to Fix

Check the time value, not the object itself:

```javascript
const date = new Date("invalid");

// ✓ CORRECT ways to detect invalid dates:
if (isNaN(date.getTime())) { }      // Most explicit
if (isNaN(date)) { }                 // Also works
if (!date.getTime()) { }             // Truthy check on time value

// ✗ WRONG - these won't work:
if (!date) { }                       // Date object exists, is truthy
if (date === null) { }               // It's not null
```

# Example

```javascript
const validDate = new Date("2026-03-18");
const invalidDate = new Date("not a date");

console.log(validDate.getTime());    // 1742332800000 (valid number)
console.log(invalidDate.getTime());  // NaN (invalid)

console.log(isNaN(validDate.getTime()));    // false
console.log(isNaN(invalidDate.getTime()));  // true
```

**Use `isNaN(date.getTime())` as your standard check** for Date validity.
