# TypeScript can't find your module or its types

> Cannot find module 'xxx' or its corresponding type declarations. ts(2307)

## What happened

You imported a package or file and TypeScript has no idea what types it exports. The code might run fine, but the compiler refuses to proceed without type information.

## Why it happens

Three main causes:

1. The package doesn't ship its own types and there's no `@types/xxx` installed
2. You're importing a non-TS file (`.css`, `.svg`, `.json`) without a declaration
3. Your `tsconfig.json` paths or `moduleResolution` settings are wrong

## How to fix it

**If it's an npm package:**

```bash
# Check if community types exist
npm install --save-dev @types/xxx

# If no @types package exists, declare it yourself
```

**If no types exist, create `src/declarations.d.ts`:**

```typescript
declare module 'xxx';
```

**If it's a file import like `.css` or `.svg`:**

```typescript
// declarations.d.ts
declare module '*.css' {
  const content: Record<string, string>;
  export default content;
}
declare module '*.svg' {
  const content: string;
  export default content;
}
```

**If `tsconfig.json` paths are wrong:**

```jsonc
{
  "compilerOptions": {
    "moduleResolution": "node",  // or "bundler" for modern setups
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"]
    }
  }
}
```

Make sure `declarations.d.ts` is included in your `tsconfig.json` via `include`.

## Don't do this

- Don't add `// @ts-ignore` on every import. You lose all type safety for that module.
- Don't set `skipLibCheck: true` thinking it fixes this. It skips checking `.d.ts` files, not missing ones.

## Still not working?

- Run `npx tsc --traceResolution` to see exactly where TS is looking for the module.
- Check that `node_modules` isn't excluded in your `tsconfig.json` `exclude` array.
- If using a monorepo, make sure `references` or `paths` point to the right package.
