# Property 'X' does not exist on type 'Y'

> Property 'xxx' does not exist on type 'yyy'. ts(2339)

## What happened

You're accessing a property that TypeScript doesn't know about on that particular type. The property might exist at runtime, but TS can't verify it at compile time.

## Why it happens

- The object's type definition is missing that property
- You're accessing a property on a union type where only some members have it
- The object comes from `document.getElementById` or similar DOM APIs that return a base type
- You have a typo in the property name

## How to fix it

**If it's a DOM element:**

```typescript
// Wrong
const el = document.getElementById('canvas');
el.width; // Property 'width' does not exist on type 'HTMLElement'

// Right: cast to the specific element type
const el = document.getElementById('canvas') as HTMLCanvasElement;
el.width; // works
```

**If it's a union type:**

```typescript
// Narrow the type first
function handle(input: string | string[]) {
  if (Array.isArray(input)) {
    input.length; // works, TS knows it's an array
  }
}
```

**If the property genuinely exists but the type is incomplete:**

```typescript
// Extend the interface
interface Window {
  myCustomProp: string;
}

// Or use bracket notation as a workaround
(obj as any)['xxx'];
```

**If it's an API response you need to type:**

```typescript
interface ApiResponse {
  data: {
    xxx: string;  // add the missing property
  };
}
```

## Don't do this

- Don't cast every object to `any` just to access properties. You lose all autocompletion and safety.
- Don't use `Object.keys(obj).includes('xxx')` as a type guard; TS won't narrow from it.

## Still not working?

- Check for typos. Seriously. `resonse.data` vs `response.data` happens more than you'd think.
- If using `Object.keys()` or `Object.entries()`, the return type is `string[]`, not `keyof T`. You may need an explicit assertion.
- Check your `lib` setting in `tsconfig.json` for DOM types (need `"lib": ["dom"]`).
