## Root Cause

**ENOTFOUND** means DNS lookup failed — the system cannot resolve the hostname to an IP address. Common causes:

1. **Wrong hostname/typo** — The URL/domain doesn't exist or is misspelled
2. **Network connectivity** — No internet connection or DNS server unreachable
3. **Domain down or blocked** — Server temporarily offline, firewall blocking it, or IP changed
4. **Invalid localhost reference** — Using `localhost` in a containerized/networked environment where it doesn't apply

## How to Fix (in order)

1. **Verify the hostname is correct**
   ```javascript
   // ✅ Correct
   fetch('https://api.example.com/endpoint')
   
   // ❌ Wrong
   fetch('https://api.exmaple.com/endpoint')  // typo
   ```

2. **Check network connectivity**
   ```bash
   ping google.com
   nslookup api.example.com  # Verify DNS resolves
   ```

3. **If it's a private/internal server**, verify:
   - It's running and accessible from your network
   - Firewall/security groups allow outbound traffic on port 80/443
   - DNS server can reach it (corporate networks may have different DNS)

4. **For localhost in containers/VMs**, use the correct address:
   ```javascript
   // ❌ Wrong (localhost doesn't exist outside the container)
   fetch('http://localhost:3000')
   
   // ✅ Correct for Docker
   fetch('http://host.docker.internal:3000')  // macOS/Windows
   fetch('http://172.17.0.1:3000')           // Linux (bridge network)
   ```

5. **Add error handling to debug**:
   ```javascript
   fetch(url).catch(err => {
     console.log(err.code);  // Will show ENOTFOUND
     console.log(err.hostname);  // The hostname that failed
   });
   ```

**Most common**: It's a typo or the server isn't running. Check your URL first.
