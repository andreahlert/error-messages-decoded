# Argument of type 'X' is not assignable to parameter of type 'Y'

> Argument of type 'string' is not assignable to parameter of type '"GET" | "POST"'. ts(2345)
> Argument of type '{ name: string; }' is not assignable to parameter of type 'Required<Config>'. ts(2345)

## What happened

You're passing an argument to a function, but the type of what you're passing doesn't match what the function expects. Similar to ts(2322) but specifically about function arguments.

## Why it happens

TypeScript widens types by default. When you declare `const method = "GET"`, TS infers it as `string`, not the literal `"GET"`. Then a function expecting `"GET" | "POST"` rejects `string` because it's too broad.

## How to fix it

**String literal widening (most common):**

```typescript
// Wrong
const method = "GET";  // inferred as string
fetch(url, { method }); // error

// Fix 1: const assertion
const method = "GET" as const;  // inferred as "GET"

// Fix 2: type annotation
const method: "GET" | "POST" = "GET";

// Fix 3: inline it
fetch(url, { method: "GET" });
```

**Object literal widening:**

```typescript
// Wrong
const options = { method: "GET", headers: {} };
// options.method is string, not "GET"

// Fix: as const on the whole object
const options = { method: "GET", headers: {} } as const;

// Or satisfies to keep the type narrow but checked
const options = {
  method: "GET",
  headers: {},
} satisfies RequestInit;
```

**Missing properties in an object argument:**

```typescript
// Read the error carefully, it tells you which properties are missing
// Then add them or mark them optional in the type definition
```

## Don't do this

- Don't use `as any` to force the argument through. The type mismatch is warning you about a real incompatibility.
- Don't change the function's parameter type to `any` to make callers happy.

## Still not working?

- If passing a callback, check that the callback's parameter types and return type match exactly.
- For generic functions, try providing the type parameter explicitly: `fn<MyType>(arg)`.
- Check if different versions of `@types` packages define the same type differently.
