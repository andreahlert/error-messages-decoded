# Root Cause

The `"not assignable to parameter of type never"` error occurs when TypeScript infers an array's element type as `never` because it can't determine what types the array should contain. This typically happens in three scenarios:

## 1. **Empty Array Without Type Annotation** (Most Common)

```typescript
const arr = [];  // TypeScript infers arr as never[]
arr.push('text');  // ❌ Error: string not assignable to never
```

TypeScript sees an empty array with no initialization and defaults to `never[]` rather than guessing the type.

## 2. **Const Assertion on Empty Array**

```typescript
const arr = [] as const;  // ❌ Type is readonly never[]
arr.push('text');
```

## 3. **Type Narrowing to Never**

```typescript
const arr: (string | number)[] = [];
if (typeof arr[0] === 'boolean') {  // Narrows to never (impossible type)
  arr.push('text');  // ❌ Error
}
```

---

# How to Fix

**Option 1: Explicit type annotation** (recommended)
```typescript
const arr: string[] = [];
arr.push('text');  // ✅ Works
```

**Option 2: Initialize with a value**
```typescript
const arr = ['initial'];  // TypeScript infers string[]
arr.push('text');  // ✅ Works
```

**Option 3: Use type assertion**
```typescript
const arr = [] as string[];
arr.push('text');  // ✅ Works
```

**Option 4: Use Array constructor** (for advanced cases)
```typescript
const arr: Array<string> = [];
arr.push('text');  // ✅ Works
```

---

**Best practice**: Always annotate empty arrays with their intended type upfront. This prevents type inference issues and makes your code's intent clearer.
