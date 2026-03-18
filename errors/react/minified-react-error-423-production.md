# Minified React error #423 in production

> Unhandled Runtime Error: Minified React error #423; visit https://reactjs.org/docs/error-decoder.html?invariant=423

## What happened
A React error occurred in a production build, but the error message is minified to save bundle size. Error #423 typically relates to hook rules violations or component rendering issues.

## Why it happens
In production builds, React replaces detailed error messages with numeric codes to reduce bundle size. Without source maps or the react-error-decoder, the actual error is hidden. Error #423 usually means a component threw during rendering.

## How to fix it
```bash
# Decode the error at React's error decoder
# Visit: https://reactjs.org/docs/error-decoder.html?invariant=423

# Build with development mode temporarily to see full errors
NODE_ENV=development npm run build

# Or enable source maps in production
# next.config.js:
# module.exports = { productionBrowserSourceMaps: true }
```

```jsx
// Add an error boundary to catch and log the full error
class ErrorBoundary extends React.Component {
  componentDidCatch(error, errorInfo) {
    console.error('React error:', error, errorInfo);
    // Send to your error tracking service
  }
  render() {
    if (this.state?.hasError) return <h1>Something went wrong.</h1>;
    return this.props.children;
  }
}
```

## Still not working?
Check the react-error-decoder page with the exact invariant number. If the error only happens in production, it may be caused by code splitting, minification mangling class names, or environment-specific behavior. Use an error tracking service (Sentry, Bugsnag) with source maps to get the real stack trace.
