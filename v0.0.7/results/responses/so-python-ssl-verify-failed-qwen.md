The `urllib` and `ssl` errors related to a failed certificate verification are typically caused by an issue with the server's SSL/TLS certificate being self-signed, expired, or not trusted by your system. Here’s what you can do to resolve this:

### 1. Check Your System's Certificate Trust Policy
- **Windows:**
  - Open `Control Panel` > `System and Security` > `Certificates`.
  - Right-click on the "Personal" store (under Trusted Root Certification Authorities) and select "View Certificate".
  - Look for any self-signed certificates that are not trusted. If you find one, click "Details" to see more information.
  - You can then add it to your certificate trust policy by clicking "Import".

- **macOS:**
  - Open `Keychain Access` (found in `/Applications/Utilities/Keychain Access.app`).
  - Go to the "Certificates" tab and look for any self-signed certificates that are not trusted.
  - Click on them, then click "Show Certificate Details", and you can add it to your certificate trust policy.

### 2. Update Your Python SSL Module
- **Windows:**
  - Ensure you have a recent version of the `ssl` module installed. You can check this by running:
    ```sh
    pip show urllib3
    ```
  - If not, update it using:
    ```sh
    pip install --upgrade urllib3
    ```

- **macOS:**
  - Ensure you have a recent version of the `ssl` module installed. You can check this by running:
    ```sh
    python3 -c "import ssl; print(ssl.OPENSSL_VERSION)"
    ```
  - If not, update it using:
    ```sh
    pip install --upgrade pyOpenSSL
    ```

### 3. Manually Verify the Certificate
- **Windows:**
  - You can manually verify the certificate by downloading the server's certificate and verifying its fingerprint against a trusted CA.
  - Use OpenSSL to check the fingerprint of the certificate:
    ```sh
    openssl x509 -in <server_certificate.pem> -fingerprint -noout
    ```
  - Compare this with your system’s trusted CA fingerprints.

- **macOS:**
  - You can manually verify the certificate by downloading it and checking its SHA256 fingerprint.
  - Use `openssl` to check the fingerprint:
    ```sh
    openssl x509 -in <server_certificate.pem> -fingerprint -noout | awk '{print $3}'
    ```
  - Compare this with your system’s trusted CA fingerprints.

### 4. Install a Trusted Certificate Authority (CA)
- **Windows:**
  - Download and install a trusted certificate authority from a reputable source.
  - This can be done through the `Certificates` pane in `Control Panel`.

- **macOS:**
  - You can manually add a trusted CA by downloading it from a trusted source.

### 5. Use a Different Certificate Authority (CA)
- If you have access to the server’s certificate, you can use a different CA that is trusted on your system.
- This involves obtaining the correct certificate and importing it into your system's trust store.

### 6. Disable SSL Verification Temporarily
- **Windows:**
  - You can temporarily disable SSL verification by setting `SSL_CERT_FILE` environment variable:
    ```sh
    export SSL_CERT_FILE=/path/to/certificate.pem
    ```
  - This is not recommended for production use as it compromises security.

### 7. Use a Proxy or Certificate Pinning
- **Proxy:**
  - If you are behind a proxy, ensure the proxy settings allow HTTPS traffic.
  - You can also configure your application to pin the certificate of the server using `ssl` module options.

By following these steps, you should be able to resolve the SSL certificate verification error and successfully make an HTTPS request.
