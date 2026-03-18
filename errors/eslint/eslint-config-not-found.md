# ESLint couldn't find the config "xxx" to extend from

> ESLint couldn't find the config "airbnb" to extend from. Please check that the name of the config is correct.
> ESLint couldn't find the config "plugin:@typescript-eslint/recommended" to extend from.

## What happened

Your ESLint config extends a shared configuration that isn't installed. ESLint can't load the base rules.

## Why it happens

- The shared config package isn't installed
- You cloned a project and didn't run `npm install`
- The config package name changed (common with major version bumps)
- Using ESLint 9 flat config syntax but referencing legacy config names

## How to fix it

**Install the missing config:**

```bash
# For "airbnb"
npm install --save-dev eslint-config-airbnb

# For "prettier"
npm install --save-dev eslint-config-prettier

# For "@typescript-eslint/recommended"
npm install --save-dev @typescript-eslint/eslint-plugin @typescript-eslint/parser

# For "next/core-web-vitals"
npm install --save-dev eslint-config-next
```

The naming convention: `extends: "xxx"` looks for `eslint-config-xxx`.

**Verify the extends value matches the installed package:**

```javascript
// .eslintrc.js
module.exports = {
  extends: [
    'airbnb',                              // eslint-config-airbnb
    'plugin:react/recommended',            // eslint-plugin-react
    'plugin:@typescript-eslint/recommended', // @typescript-eslint/eslint-plugin
    'prettier',                            // eslint-config-prettier (should be last)
  ],
};
```

**If migrating to ESLint 9 flat config:**

```javascript
// eslint.config.js - extends doesn't exist, use spread instead
import airbnb from 'eslint-config-airbnb';
import tseslint from 'typescript-eslint';

export default [
  ...tseslint.configs.recommended,
  // flat config uses arrays, not "extends"
];
```

## Don't do this

- Don't remove the `extends` to make the error go away. You'll lose all the shared rules.
- Don't copy-paste rules from the shared config into your own config. Just install the package.

## Still not working?

- Some configs have peer dependencies. Run `npm info eslint-config-airbnb peerDependencies` to see what else you need.
- Use `npx install-peerdeps eslint-config-airbnb --dev` to install a config with all its peers.
- If using npm workspaces or pnpm, the config might be hoisted to a different `node_modules`. Check ESLint's resolution with `--debug`.
