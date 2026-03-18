# TypeScript union type too complex

> error TS2590: Expression produces a union type that is too complex to represent.

## What happened
TypeScript's type checker gave up evaluating a type expression because the resulting union has too many members to represent.

## Why it happens
Deeply nested generic types, recursive mapped types, or large discriminated unions can cause combinatorial explosion. For example, chaining many `.pick()` or `.merge()` calls on Zod schemas, or template literal types with multiple unions, can produce millions of type variants.

## How to fix it
```ts
// Break complex types into intermediate type aliases
// Instead of one giant chained type:
type Bad = Schema.pick('a').merge(Other).extend(More);

// Extract intermediate types to reduce complexity
type Step1 = Schema.pick('a');
type Step2 = Step1 & Other;
type Result = Step2 & More;

// For discriminated unions, simplify by reducing union members
type Action =
  | { type: 'create'; payload: CreatePayload }
  | { type: 'update'; payload: UpdatePayload }
  | { type: 'delete'; payload: DeletePayload };
// Keep discriminated unions focused rather than combining everything
```

## Still not working?
If using Zod, Prisma, or tRPC, check if newer versions have fixed the type complexity. Add explicit type annotations instead of relying on inference. As a last resort, use `as` assertions at the boundary to cap type expansion, but keep the internal types correct.
