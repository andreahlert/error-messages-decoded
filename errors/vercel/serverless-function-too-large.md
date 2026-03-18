# Serverless function size too large

> Function size too large: 262144000 bytes

## What happened
Your serverless function deployment was rejected because the bundled function exceeds the platform's size limit (typically 50MB zipped for AWS Lambda, 250MB unzipped, or similar limits on Vercel/Netlify).

## Why it happens
The function bundle includes your code plus all dependencies from `node_modules`. Large dependencies (AWS SDK v2, Puppeteer, sharp, Prisma with all engines) can easily push the bundle over the limit. Bundlers may also include unused code paths if tree-shaking is not configured.

## How to fix it

Use esbuild or webpack to bundle and tree-shake your function:
```bash
# Install esbuild
npm install --save-dev esbuild

# Bundle with tree shaking
npx esbuild src/handler.ts --bundle --platform=node --target=node18 \
  --outfile=dist/handler.js --minify --tree-shaking=true \
  --external:aws-sdk --external:@aws-sdk
```

Mark large dependencies as external if they are provided by the runtime:
```javascript
// serverless.yml (Serverless Framework)
custom:
  esbuild:
    bundle: true
    minify: true
    external:
      - aws-sdk
      - '@aws-sdk/*'
    exclude:
      - 'aws-sdk'
```

Use `@vercel/nft` (Node File Trace) for Vercel to only include used files:
```json
// vercel.json
{
  "functions": {
    "api/**/*.ts": {
      "memory": 1024,
      "maxDuration": 30
    }
  }
}
```

Exclude unnecessary files:
```bash
# .vercelignore or .funcignore
node_modules/.cache
tests/
docs/
*.test.js
*.spec.js
```

## Still not working?
- Check which dependencies are the largest: `npx cost-of-modules` or `du -sh node_modules/* | sort -rh | head -20`.
- For Prisma, only include the engine for your target platform: `binaryTargets = ["rhel-openssl-3.0.x"]` in `schema.prisma`.
- For sharp, use Lambda Layers or install the platform-specific version: `npm install --platform=linux --arch=x64 sharp`.
- Split large functions into smaller ones with shared layers for common dependencies.
