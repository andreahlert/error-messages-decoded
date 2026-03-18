# Object is possibly 'undefined'

> Object is possibly 'undefined'. ts(2532)
> Object is possibly 'null'. ts(2531)
> Object is possibly 'null' or 'undefined'. ts(18048)

## What happened

You're trying to access a property or call a method on something that might be `null` or `undefined`. TypeScript is stopping you from a potential runtime crash.

## Why it happens

The variable's type includes `undefined` or `null`. This often comes from:

- Optional properties (`prop?: string` means `string | undefined`)
- `Array.find()` which returns `T | undefined`
- `Map.get()` which returns `T | undefined`
- `document.getElementById()` which returns `HTMLElement | null`

## How to fix it

**Optional chaining (safest):**

```typescript
const len = user?.address?.street?.length;
```

**Null check:**

```typescript
const el = document.getElementById('app');
if (el) {
  el.textContent = 'loaded'; // TS knows el is not null here
}
```

**Non-null assertion (when you're 100% sure):**

```typescript
// The ! tells TS "trust me, this isn't null"
const el = document.getElementById('app')!;
```

**Nullish coalescing for defaults:**

```typescript
const name = user?.name ?? 'Anonymous';
```

**With array `.find()`:**

```typescript
const item = items.find(i => i.id === targetId);
if (!item) {
  throw new Error(`Item ${targetId} not found`);
}
// item is now narrowed to non-undefined below this point
item.name; // works
```

## Don't do this

- Don't disable `strictNullChecks` in tsconfig. That hides bugs instead of fixing them.
- Don't spam `!` everywhere. Each one is a promise that the value exists, and broken promises become runtime errors.

## Still not working?

- If TS doesn't narrow after your `if` check, you might be checking a different variable than you think. Assign to a local variable and check that.
- Destructuring can lose narrowing: `const { data } = response` won't keep the narrowing from a previous `if (response.data)` check.
