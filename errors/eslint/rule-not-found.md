# Definition for rule 'xxx' was not found

> Definition for rule 'react/jsx-uses-react' was not found.
> Definition for rule '@typescript-eslint/no-explicit-any' was not found.
> Definition for rule 'import/order' was not found.

## What happened

ESLint config references a rule that doesn't exist. Either the plugin that provides it isn't installed, or the rule name is wrong.

## Why it happens

- The plugin isn't installed (`eslint-plugin-react`, `@typescript-eslint/eslint-plugin`, etc.)
- The plugin is installed but not listed in the `plugins` array
- The rule was renamed or removed in a newer version of the plugin
- Typo in the rule name

## How to fix it

**Install the missing plugin:**

```bash
# For react rules
npm install --save-dev eslint-plugin-react

# For @typescript-eslint rules
npm install --save-dev @typescript-eslint/eslint-plugin

# For import rules
npm install --save-dev eslint-plugin-import
```

**Make sure the plugin is listed in your config:**

```javascript
// .eslintrc.js (ESLint 8)
module.exports = {
  plugins: ['react', '@typescript-eslint', 'import'],
  rules: {
    'react/jsx-uses-react': 'off',
    '@typescript-eslint/no-explicit-any': 'warn',
    'import/order': 'error',
  },
};
```

```javascript
// eslint.config.js (ESLint 9)
import react from 'eslint-plugin-react';
import tseslint from 'typescript-eslint';

export default [
  { plugins: { react } },
  ...tseslint.configs.recommended,
];
```

**If the rule was removed in a newer version:**

```bash
# Check available rules
npx eslint --print-config file.js | grep "rule-name"
```

Remove the rule from your config if it no longer exists.

## Don't do this

- Don't downgrade the plugin to an old version just to keep a deprecated rule. Update your config to use the replacement rule.
- Don't install plugins globally. ESLint resolves plugins from the project's `node_modules`.

## Still not working?

- In ESLint 9 flat config, plugins are configured differently. You import them directly instead of listing string names.
- Check if you're extending a shared config that requires a plugin you haven't installed.
- Run `npx eslint --debug file.js 2>&1 | grep "Loading plugin"` to see which plugins ESLint actually loads.
