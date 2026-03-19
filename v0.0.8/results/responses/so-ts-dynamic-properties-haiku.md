**Root cause**: TypeScript's type system enforces strict property definitions. You can only assign properties that are explicitly declared in the object's type. Assigning an unknown property violates the type contract.

**Fix options** (from best to worst):

**1. Use index signature in your type** (recommended)
```typescript
interface MyObject {
  name: string;
  [key: string]: any; // Allow any dynamic properties
}

const obj: MyObject = { name: "test" };
obj.age = 25; // ✅ Works
```

**2. Use `Record<string, T>` type**
```typescript
const obj: Record<string, any> = {};
obj.foo = "bar";
obj.age = 25; // ✅ Works
```

**3. Use `as const` assertion** (if values are known at assignment)
```typescript
const obj = {
  name: "test",
  age: 25,
} as const; // ✅ Works, but makes properties readonly
```

**4. Extend `Record` in your interface**
```typescript
interface MyObject extends Record<string, any> {
  name: string; // Explicit properties still work
}
```

**Best practice**: Use option 1 or 2 depending on your needs. The index signature `[key: string]: any` is clearest when you have *some* known properties plus dynamic ones. `Record<string, T>` is best for fully dynamic objects.

Avoid using `as any` casts—they bypass type safety entirely.
