# React createContext is not a function

> TypeError: (0 , _react.createContext) is not a function

## What happened
A library or component calls `React.createContext()` but the imported React version does not have this function, indicating a version mismatch between React packages.

## Why it happens
Multiple versions of React are installed. A dependency expects one version of `react` but gets another. This commonly happens when `react` and `react-dom` are at different versions, or a library bundles its own copy of React. The `createContext` API exists in React 16.3+ but can fail if the wrong React instance is loaded.

## How to fix it
```bash
# Check for version mismatches
npm ls react
npm ls react-dom

# Ensure react and react-dom are the same version
npm install react@latest react-dom@latest

# Deduplicate React
npm dedupe

# Force a single React version via overrides
# In package.json:
# "overrides": {
#   "react": "$react",
#   "react-dom": "$react-dom"
# }
```

## Still not working?
For monorepos, ensure React is hoisted to the root. Check peer dependency warnings during install. In webpack, use `resolve.alias` to force a single React path. For yarn workspaces, add React to `resolutions`. Run `npm ls react` to confirm only one version remains.
