# Type 'X' is not assignable to type 'Y'

> Type 'string' is not assignable to type 'number'. ts(2322)
> Type 'string | undefined' is not assignable to type 'string'. ts(2322)

## What happened

You're trying to put a value somewhere that expects a different type. TypeScript is telling you the shape of your data doesn't match what's expected.

## Why it happens

The value you're assigning has a wider or incompatible type compared to the target. Most common scenarios:

- A function returns `string | undefined` but you're assigning to a `string` variable
- You're passing a string literal where a union type or enum is expected
- An API response is typed as `any` or `unknown` and you're assigning it directly

## How to fix it

**If the type includes `undefined` or `null`:**

```typescript
// Option 1: Narrow with a check
const value = getData(); // string | undefined
if (value !== undefined) {
  const name: string = value; // works
}

// Option 2: Non-null assertion (only if you're sure)
const name: string = value!;

// Option 3: Default value
const name: string = value ?? 'default';
```

**If it's a string literal vs union type:**

```typescript
// Wrong
const status: 'active' | 'inactive' = someString;

// Right: assert it
const status: 'active' | 'inactive' = someString as 'active' | 'inactive';

// Better: validate it
function isStatus(s: string): s is 'active' | 'inactive' {
  return s === 'active' || s === 'inactive';
}
```

**If it's an object shape mismatch:**

```typescript
// Check what properties are missing or extra
// TypeScript usually tells you in the full error message
// Read the FULL error, not just the first line
```

## Don't do this

- Don't cast everything with `as any`. You're turning off the compiler that's trying to save you.
- Don't use `// @ts-ignore`. The error is telling you about a real potential bug.

## Still not working?

- Hover over the variable in your IDE to see the full inferred type.
- Check if you have mismatched package versions causing duplicate type definitions.
- If types come from `@types/xxx`, make sure versions are compatible with your library version.
