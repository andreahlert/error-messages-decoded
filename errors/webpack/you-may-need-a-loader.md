# You may need an appropriate loader to handle this file type

> Module parse failed: Unexpected token (1:0)
> You may need an appropriate loader to handle this file type, currently no loaders are configured to process this file.

## What happened

Webpack encountered a file type it doesn't know how to handle. Webpack only understands JavaScript and JSON by default. Everything else (CSS, TypeScript, images, SVG) needs a loader.

## Why it happens

- Importing a CSS file without `css-loader`
- Importing TypeScript without `ts-loader` or `babel-loader`
- Importing images or fonts without `file-loader` or `asset/resource`
- Using JSX without Babel configured
- The `test` regex in your loader config doesn't match the file

## How to fix it

**For CSS:**

```bash
npm install --save-dev css-loader style-loader
```

```javascript
// webpack.config.js
module.exports = {
  module: {
    rules: [
      { test: /\.css$/, use: ['style-loader', 'css-loader'] },
    ],
  },
};
```

**For TypeScript:**

```bash
npm install --save-dev ts-loader typescript
```

```javascript
{ test: /\.tsx?$/, use: 'ts-loader', exclude: /node_modules/ }
```

**For images (Webpack 5):**

```javascript
{
  test: /\.(png|jpg|gif|svg)$/,
  type: 'asset/resource', // built-in, no loader needed
}
```

**For JSX with Babel:**

```bash
npm install --save-dev babel-loader @babel/core @babel/preset-react
```

```javascript
{
  test: /\.jsx?$/,
  exclude: /node_modules/,
  use: {
    loader: 'babel-loader',
    options: { presets: ['@babel/preset-react'] },
  },
}
```

## Don't do this

- Don't process `node_modules` with your loaders unless specifically needed. It slows down builds massively.
- Don't install Webpack 4 loaders for Webpack 5. Check compatibility (e.g., `file-loader` is replaced by `asset/resource` in v5).

## Still not working?

- Check that your `test` regex actually matches the file. `\.css$` matches `.css` but not `.module.css` unless you use `/\.css$/` (which matches both).
- Loaders run in reverse order in the `use` array. `['style-loader', 'css-loader']` means css-loader runs first, then style-loader.
- If using a monorepo, the file might be outside the project root. Check `include` paths in your loader config.
