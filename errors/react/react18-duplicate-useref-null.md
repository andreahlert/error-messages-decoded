# React useRef returns null due to duplicate React

> TypeError: Cannot read properties of null (reading 'useRef')

## What happened
A React hook (`useRef`) returned null or the component crashed because there are multiple copies of React loaded in the bundle.

## Why it happens
When two different versions of React are bundled (e.g., your app uses React 18 but a dependency bundles its own React 17), hooks break because they rely on a shared internal state. The component and the hook end up referencing different React instances.

## How to fix it
```bash
# Check for duplicate React versions
npm ls react
npm ls react-dom

# Deduplicate
npm dedupe

# If a dependency bundles its own React, force a single version
# package.json
# "overrides": {
#   "react": "$react",
#   "react-dom": "$react-dom"
# }
```

## Still not working?
Check your bundler config for multiple React aliases. In webpack, add `resolve.alias: { react: path.resolve('./node_modules/react') }`. For yarn, use `resolutions` instead of `overrides`. Verify with `npm ls react` that only one version appears.
