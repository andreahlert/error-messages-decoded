The `urllib` and `ssl` errors related to a failed certificate verification are typically caused by an issue where your system cannot trust the SSL/TLS certificate presented by the server you're trying to connect to over HTTPS.

### Root Cause:
1. **Incorrect Certificate**: The server's certificate might be self-signed, expired, or not trusted by your local CA (Certificate Authority).
2. **Missing Intermediate Certificates**: Your system may lack intermediate certificates required for a full chain of trust.
3. **Incompatible SSL/TLS Version**: The version of the SSL/TLS protocol used on both sides is incompatible.
4. **Incorrect Certificate Chain**: The certificate presented by the server might be missing one or more intermediate certificates.

### Steps to Fix:

#### 1. Check Your System's CA Configuration:
   - Ensure that your system trusts the root certificate authority (CA) that issued the SSL/TLS certificate you're trying to connect to.
   - You can check this in `certifi` by running:
     ```bash
     pip install certifi
     ```
   - Then, update your Python's SSL context with the CA bundle:
     ```python
     import ssl
     from urllib.request import urlopen

     # Update the default SSL context to include the root certificates.
     context = ssl.create_default_context()
     context.load_verify_locations(cafile='path/to/root-ca-bundle.pem')

     try:
         response = urlopen('https://example.com', context=context)
         print(response.read())
     except urllib.error.HTTPError as e:
         print(f"HTTP Error: {e}")
     except urllib.error.URLError as e:
         print(f"URL Error: {e.reason}")
     ```

#### 2. Verify the Server's Certificate Chain:
   - Ensure that the server certificate chain is complete and includes all intermediate certificates.
   - You can manually verify the chain by checking the `cert.pem` file on your system or using a tool like OpenSSL.

#### 3. Update Your System's CA Bundle:
   - If you're running an older version of Python, consider updating to a more recent one that comes with updated SSL/TLS certificates.
   - Alternatively, download and install the latest root certificate bundle from `certifi`.

#### 4. Use a Different Certificate Authority (CA):
   - If your system does not trust the CA presented by the server, you might need to add it manually or switch to a different trusted CA.

### Example Code:
Here's an example of how you can handle SSL errors in Python:

```python
import urllib.request

try:
    response = urllib.request.urlopen('https://example.com')
except urllib.error.HTTPError as e:
    print(f"HTTP Error: {e}")
except urllib.error.URLError as e:
    if hasattr(e, 'reason'):
        print(f"Reason: {e.reason}")
    elif hasattr(e, 'code'):
        print(f"Code: {e.code}")
```

### Additional Tips:
- **Use a Trusted Certificate Authority (CA)**: Consider using a trusted CA like Let's Encrypt or Comodo for your development environment.
- **Check Your Network Configuration**: Ensure that your network configuration is not blocking the connection to the server.

By following these steps, you should be able to resolve the `CERTIFICATE_VERIFY_FAILED` error and successfully connect to HTTPS servers.
