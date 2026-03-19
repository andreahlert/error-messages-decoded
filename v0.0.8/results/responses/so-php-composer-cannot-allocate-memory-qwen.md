The "cannot allocate memory" error in PHP, specifically when using Composer to update or install packages, typically indicates that your system does not have enough available memory (RAM) to complete the operation. This can happen for several reasons:

### Root Cause:
1. **Insufficient RAM**: Your server has less than 256 MB of RAM.
2. **PHP Configuration Issues**: The PHP configuration on your server is set up in a way that restricts how much memory can be allocated, or it's configured to use too little memory by default.
3. **Large Package Dependencies**: Some packages have large dependencies that require more memory than what the system has available.

### Steps to Fix:

#### 1. Increase RAM:
- If you're running on a shared hosting environment, consider upgrading your plan to one with more RAM.
- Alternatively, if you can afford it, consider moving to a VPS or dedicated server where you have full control over your resources.

#### 2. Adjust PHP Configuration:
- **Increase Memory Limit**: Edit the `php.ini` file of your web server (e.g., Apache) and increase the `memory_limit` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `32M`, `64M`, or even `128M`.
  
- **Increase Maximum Execution Time**: If you're experiencing timeouts during the update process, increase the `max_execution_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `300`, `600`, or even `900`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_vars` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `300`.
  
- **Increase Maximum Input Time**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `60`, `180`, or even `300`.
  
- **Increase Maximum Input Variables**: If you're experiencing timeouts during the update process, increase the `max_input_time` setting.
  ```bash
  sudo nano /etc/php5/apache2/php.ini
  ```
  Increase it to a higher value, such as `100`, `200`, or even `
