# Root Cause

TypeScript's type system doesn't know what properties your object has when you use a string variable as an index. The string could reference a property that doesn't exist, so TypeScript won't allow it without explicit type information about valid keys.

# Solutions

**1. Use `keyof` (most type-safe)**
```typescript
const obj = { name: 'John', age: 30 };
const key: keyof typeof obj = 'name'; // ✓ Works
const value = obj[key];
```

**2. Define valid keys as a union type**
```typescript
type Keys = 'name' | 'age';
const key: Keys = 'name';
const value = obj[key]; // ✓ Works
```

**3. Add an index signature to your type**
```typescript
interface MyObject {
  name: string;
  age: number;
  [key: string]: string | number; // ✓ Allows string indexing
}

const key: string = 'name';
const value: string | number = obj[key];
```

**4. Assert the key is valid (less safe, only when you're certain)**
```typescript
const key: keyof typeof obj = 'name' as keyof typeof obj;
const value = obj[key];
```

# When to Use Each

- **`keyof`**: When you have a specific object and want type-safe key access
- **Union type**: When keys are known but dynamic (API responses, config objects)
- **Index signature**: When you need to accept arbitrary string keys but still have type safety for values
- **Type assertion**: Only as a last resort when you're 100% sure the key exists

The first two solutions are preferred because they maintain TypeScript's type safety.
