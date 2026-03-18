# No inputs were found in config file 'tsconfig.json'

> error TS18003: No inputs were found in config file '/path/to/tsconfig.json'.
> Specified 'include' paths were '["**/*"]' and 'exclude' paths were '["node_modules"]'.

## What happened

TypeScript found your `tsconfig.json` but it doesn't match any `.ts` or `.tsx` files to compile. The config is valid, but it's pointing at nothing.

## Why it happens

- Your `include` pattern doesn't match any files
- All your TS files are inside a directory that's in `exclude`
- You just initialized the project and haven't created any `.ts` files yet
- The `rootDir` points to a directory that doesn't contain TS files

## How to fix it

**If you just initialized the project:**

```bash
# Create at least one TS file
echo 'export {};' > src/index.ts
```

**If your files are in `src/` but include doesn't cover it:**

```jsonc
{
  "compilerOptions": { /* ... */ },
  "include": ["src/**/*"]
}
```

**If you're using a monorepo with project references:**

```jsonc
// Make sure each referenced tsconfig includes its own files
{
  "include": ["src"],
  "references": [
    { "path": "../shared" }
  ]
}
```

**If your `exclude` is too aggressive:**

```jsonc
{
  "exclude": ["node_modules", "dist"]
  // Don't accidentally exclude "src" or "."
}
```

## Don't do this

- Don't add `"files": []` with an empty array thinking it means "all files." It means "no files."
- Don't set `include` to `["*"]`. That only matches the root directory, not subdirectories. Use `["**/*"]` or `["src"]`.

## Still not working?

- Run `npx tsc --listFiles` to see exactly which files TS is picking up.
- Check if you have a `tsconfig.build.json` that's being used instead of `tsconfig.json`.
- If you have only `.js` files, you need `allowJs: true` in compilerOptions.
