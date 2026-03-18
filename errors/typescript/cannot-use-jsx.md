# Cannot use JSX unless the '--jsx' flag is provided

> Cannot use JSX unless the '--jsx' flag is provided. ts(17004)

## What happened

You have JSX syntax (`<Component />`) in a `.tsx` file but TypeScript doesn't know how to handle it because the `jsx` compiler option isn't set.

## Why it happens

Your `tsconfig.json` is missing the `jsx` option, or your file has a `.ts` extension instead of `.tsx`. This also happens when you have multiple tsconfig files and your IDE is picking up the wrong one.

## How to fix it

**Add `jsx` to your `tsconfig.json`:**

```jsonc
{
  "compilerOptions": {
    "jsx": "react-jsx"  // React 17+ with automatic runtime
  }
}
```

Common values for `jsx`:

- `"react-jsx"` for React 17+ (no need to `import React`)
- `"react"` for React 16 and older (requires `import React` in every file)
- `"react-jsxdev"` for development with extra debugging info
- `"preserve"` if a bundler like Vite/Next handles the transform

**Make sure your file extension is `.tsx`, not `.ts`.**

```bash
mv src/components/Button.ts src/components/Button.tsx
```

**If using Next.js and it still complains:**

```bash
# Next.js auto-generates tsconfig settings on first run
# Delete and restart
rm tsconfig.json
npm run dev
```

## Don't do this

- Don't add `"jsx": "react"` if you're on React 17+. You'll get unnecessary `import React` requirements in every file.
- Don't use `createElement` calls manually to avoid this error. Fix the config instead.

## Still not working?

- Restart your TS server in VSCode: `Ctrl+Shift+P` > "TypeScript: Restart TS Server".
- Check if you have a `tsconfig.app.json` or `tsconfig.build.json` that overrides the base config. Your editor might use one while the build uses another.
- Verify your IDE is using the workspace TypeScript version, not a global one.
