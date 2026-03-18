The error message "error:0308010C:digital envelope routines::unsupported" typically indicates that a cryptographic operation was attempted with an unsupported algorithm, likely due to changes in Node.js versions 17 and 18. This can happen when upgrading from older Node.js versions.

### Root Cause:
The root cause of this error is the change in how OpenSSL handles certain encryption algorithms between Node.js versions 16 and 17/18. Specifically:

- **Node.js 16**: Introduced a new default for SSL/TLS cipher suites, which includes some that are not supported by older browsers or environments.
- **Node.js 17/18**: Further refined the default settings to ensure compatibility with modern web applications and stricter security standards.

### Fix:
To resolve this issue, you need to update your Node.js version back to 16. Here’s how:

#### Option 1: Update Node.js
If you have multiple versions of Node.js installed on your system, you can uninstall the newer versions (Node.js 17/18) and install Node.js 16.

```bash
# Uninstall Node.js 17/18
sudo rm -rf /usr/local/bin/node@17
sudo rm -rf /usr/local/bin/node@18

# Install Node.js 16
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### Option 2: Use a Virtual Environment
If you are using a virtual environment, ensure that the correct version of Node.js is installed in it.

```bash
# Activate your virtual environment (e.g., python3.9)
source /path/to/venv/bin/activate

# Install Node.js 16
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### Option 3: Modify the `package.json` Script
If you are using a script in your `package.json`, ensure that it specifies Node.js version 16.

```json
"scripts": {
    "build": "node@16 ./path/to/your/script"
}
```

### Additional Steps:
- **Check for Other Dependencies**: Ensure there are no other dependencies that might be using newer versions of Node.js. You can check this by looking at the `package.json` files or running `npm ls <dependency>`.

- **Update Webpack Configuration**: If you're using Webpack, ensure your configuration is compatible with Node.js 16. This usually involves updating any references to specific version numbers in your webpack.config file.

By following these steps, you should be able to resolve the "error:0308010C:digital envelope routines::unsupported" error and successfully run `npm run build` after upgrading to Node.js 17/18.
