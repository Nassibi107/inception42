<h1 align="center" id="title">inception42</h1>

<p id="description">Inception is a comprehensive containerized web application project designed to demonstrate the power of Docker and Docker Compose in creating and managing isolated environments for web services. The project sets up a full-fledged web stack comprising MariaDB Nginx and WordPress orchestrated seamlessly using Docker Compose. This setup allows for scalable efficient and portable development and deployment processes making it ideal for developers DevOps engineers and anyone interested in modern web application management.</p>

---

## MariaDB Configuration

### `mariaDB_reloading()`

The command starts the MariaDB (or MySQL) server using `mysqld_safe` with the following configurations:

- **Port:** The server listens on port 3306.
- **Accessibility:** The server is accessible from any network interface (0.0.0.0).
- **Data Directory:** The data directory is set to `/var/lib/mysql`.

This setup is commonly used in Docker containers or cloud-based environments to ensure MariaDB is accessible from any IP address (e.g., in a web app).

---

## Nginx Configuration

This code is a configuration for an Nginx server set up to serve a WordPress site over SSL.

### Events Context: Handles connection processing

```nginx
events {
    worker_connections 1024;
}
```

### HTTP Context: Configures HTTP server behaviors

- **Include MIME Types:** Includes MIME type mappings to identify file types.
  ```nginx
  include /etc/nginx/mime.types;
  ```
- **Access Log:** Specifies the log file for incoming requests.
  ```nginx
  access_log /var/log/nginx/access.log;
  ```
- **Error Log:** Specifies the log file for errors.
  ```nginx
  error_log /var/log/nginx/error.log;
  ```

### Server Block: Defines settings for a virtual host

```nginx
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    ssl_certificate  /etc/nginx/ssl/ynassibi.crt;
    ssl_certificate_key /etc/nginx/ssl/ynassibi.key;
    ssl_protocols TLSv1.3;

    root /var/www/wordpress;
    server_name ynassibi.42.fr;
    index index.php;

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass wordpress:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

#### Key Directives:

- \`\`: Enables HTTPS on port 443.
- `** & **`**:** Define the paths to the SSL certificate and private key for secure communication.
- \`\`**:** Enforces the latest TLS protocol.
- \`\`**:** Specifies the WordPress file directory.
- \`\`**:** Sets the domain name (`ynassibi.42.fr`).
- \`\`**:** Configures PHP file handling, directing PHP requests to a PHP-FPM service.

### OpenSSL Command to Generate SSL Certificates

```bash
openssl req -x509 -nodes -out /etc/nginx/ssl/ynassibi.crt -keyout /etc/nginx/ssl/ynassibi.key -subj "/C=MO/ST=KH/L=KH/O=1337/OU=1337/CN=ynassibi.42.fr/UID=ynassibi"
```

---

## WordPress Configuration

### PHP-FPM Process Management (`pm = dynamic`):

- **Dynamic Process Management:** Automatically scales PHP worker processes based on traffic demand.
- **Configuration:**
  ```ini
pm = dynamic
pm.max_children = 50          # Maximum number of PHP processes.
pm.start_servers = 5          # Number of PHP processes to start initially.
pm.min_spare_servers = 5      # Minimum number of idle PHP processes to keep.
pm.max_spare_servers = 35     # Maximum number of idle PHP processes allowed.
  ```

#### Idle Processes:

- **Active:** Handling requests.
- **Idle:** Waiting for requests.

### Differences Between FastCGI and CGI:

| Feature          | CGI                          | FastCGI                |
| ---------------- | ---------------------------- | ---------------------- |
| Process Handling | Spawns a new process/request | Persistent processes   |
| Performance      | Slower                       | Faster                 |
| Resource Usage   | High                         | Efficient              |
| Scalability      | Limited                      | Highly scalable        |
| Communication    | stdin/stdout                 | Persistent connections |

---

## Bonus Part

### Adminer

Adminer is a lightweight, fast database management tool written in PHP. It offers a simpler and faster alternative to phpMyAdmin while providing similar functionality.

### cAdvisor

cAdvisor (Container Advisor) is an open-source monitoring tool developed by Google to analyze and monitor resource usage and performance characteristics of containers.

#### Key Features:

- **Resource Monitoring:** Tracks CPU, memory, file system, and network usage.
- **Prometheus Integration:** Exposes metrics in Prometheus format, visualizable using Grafana.
- **Compatibility:** Supports Docker and other container runtimes.

#### cAdvisor Docker Configuration:

```yaml
cadvisor:
  container_name: cadvisor
  image: cadvisor:13
  build: ./requirements/bonus/cadvisor
  ports:
    - "8080:8080"
  networks:
    - inception
  volumes:
    - /:/rootfs:ro
    - /var/run:/var/run:ro
    - /sys:/sys:ro
    - /var/lib/docker/:/var/lib/docker:ro
```

#### Mounted Volumes:

- \`\`: Access to the host filesystem.
- \`\`: Access to Unix domain sockets.
- \`\`: Access to system-level metrics.
- \`\`: Access to Docker metadata.

