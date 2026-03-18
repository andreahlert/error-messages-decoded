# Parsing error: Unexpected token

> Parsing error: Unexpected token
> Parsing error: Unexpected token =>
> Parsing error: Unexpected token {

## What happened

ESLint's parser can't understand your code syntax. It's not a linting rule violation; the parser itself choked on something it doesn't recognize.

## Why it happens

- ESLint's default parser doesn't understand TypeScript or modern JSX
- Missing `@typescript-eslint/parser` for `.ts`/`.tsx` files
- `ecmaVersion` is set too low for the syntax you're using
- ESLint is parsing a file it shouldn't (config files, build output)

## How to fix it

**For TypeScript:**

```bash
npm install --save-dev @typescript-eslint/parser @typescript-eslint/eslint-plugin
```

```javascript
// .eslintrc.js (ESLint 8)
module.exports = {
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint'],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
};
```

```javascript
// eslint.config.js (ESLint 9 flat config)
import tseslint from 'typescript-eslint';
export default [
  ...tseslint.configs.recommended,
];
```

**For modern JavaScript syntax:**

```javascript
// .eslintrc.js
module.exports = {
  parserOptions: {
    ecmaVersion: 'latest',  // or 2024, 2023, etc.
    sourceType: 'module',
    ecmaFeatures: { jsx: true },
  },
};
```

**Exclude files that shouldn't be linted:**

```javascript
// .eslintignore
dist/
build/
node_modules/
*.config.js
```

## Don't do this

- Don't downgrade your code syntax to match the parser. Upgrade the parser.
- Don't set `ecmaVersion: 5` thinking it means "ES5 and above." It means "only ES5."

## Still not working?

- If using ESLint 9 with flat config, the parser is configured differently. Check the migration guide.
- Make sure the parser package is actually installed, not just listed in config.
- Check if your IDE's ESLint extension is using a different ESLint version than your project.
- For `.vue` or `.svelte` files, you need the framework-specific parser (`vue-eslint-parser`, `svelte-eslint-parser`).
