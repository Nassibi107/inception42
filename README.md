<h1 align="center" id="title">inception42</h1>

<p id="description">Inception is a comprehensive containerized web application project designed to demonstrate the power of Docker and Docker Compose in creating and managing isolated environments for web services. The project sets up a full-fledged web stack comprising MariaDB Nginx and WordPress orchestrated seamlessly using Docker Compose. This setup allows for scalable efficient and portable development and deployment processes making it ideal for developers DevOps engineers and anyone interested in modern web application management.</p>

# mariadb congif 

mariaDB_reloading () : 

The command starts the MariaDB (or MySQL) server using mysqld_safe with the following configurations:

The server listens on port 3306.
The server is accessible from any network interface (0.0.0.0).
The data directory is set to /var/lib/mysql.
This command is often used in Docker containers or cloud-based environments where you might want MariaDB to be accessible from any IP (for example, in a web app).

# nginx config 

CONFIG FILE :

This Nginx configuration file is for setting up an Nginx server to serve a WordPress site with SSL encryption and handle PHP requests, along with specific settings for Adminer (a database management tool). Here’s a concise breakdown of its main parts:

1. Global Event Settings:
nginx
Copy
events {
    worker_connections 1024;
}
worker_connections 1024: Defines the maximum number of simultaneous connections each worker process can handle. 1024 is a common setting for typical web servers.
2. HTTP Block (Main Configuration):
nginx
Copy
http {
    include /etc/nginx/mime.types;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
include /etc/nginx/mime.types: Loads MIME type definitions to serve proper content types for different file extensions.
access_log: Defines the location of the log file for incoming requests.
error_log: Defines the location of the log file for server errors.
3. Server Block (Defines a Virtual Host):
nginx
Copy
server {
    listen 443 ssl;
    listen [::]:443 ssl;
listen 443 ssl: Tells Nginx to listen on port 443 (the default for HTTPS) and use SSL/TLS encryption.
listen [::]:443 ssl: Ensures Nginx also listens for IPv6 traffic on port 443.
nginx
Copy
ssl_certificate  /etc/nginx/ssl/ynassibi.crt;
ssl_certificate_key /etc/nginx/ssl/ynassibi.key;
ssl_protocols TLSv1.3;
ssl_prefer_server_ciphers off;
ssl_certificate: Points to the SSL certificate file.
ssl_certificate_key: Points to the SSL certificate's private key.
ssl_protocols TLSv1.3: Specifies that only TLSv1.3 (the latest version of TLS) should be used for secure connections.
ssl_prefer_server_ciphers off: Disables the preference for the server’s cipher suite.
nginx
Copy
root /var/www/wordpress;
server_name ynassibi.42.fr;
index index.php;
root /var/www/wordpress: Defines the root directory for the website (WordPress site in this case).
server_name ynassibi.42.fr: Sets the domain name for the server (to match the site’s URL).
index index.php: Specifies the default index file (index.php for WordPress).
4. PHP Processing:
nginx
Copy
location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass wordpress:9000;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
}
location ~ .php$: This block handles PHP files (matching URLs ending with .php).
include snippets/fastcgi-php.conf: Includes configuration for handling PHP via FastCGI.
fastcgi_pass wordpress:9000: Forwards PHP requests to the wordpress service (presumably running on port 9000).
fastcgi_param SCRIPT_FILENAME: Sets the full path to the PHP script being executed.
5. Adminer Handling:
nginx
Copy
location ~ ^/adminer(/.*$|$) {
    fastcgi_index index.php;
    include /etc/nginx/fastcgi_params;
    fastcgi_param SCRIPT_FILENAME /var/www/html/index.php;
    fastcgi_pass adminer:9000;
}
location ~ ^/adminer: Matches any URL starting with /adminer.
This block handles PHP requests for Adminer (the database management tool) by passing them to a FastCGI service running on adminer:9000.
6. Default Routing:
nginx
Copy
location / {
    try_files $uri $uri/ /index.php?$args;
}
try_files $uri $uri/ /index.php?$args: Tries to serve static files (like images or CSS) and, if not found, forwards the request to index.php (as WordPress typically handles dynamic requests through PHP).
7. Security Settings:
nginx
Copy
location ~ /\.ht {
    deny all;
}
location ~ /.ht: Denies access to any file starting with .ht, such as .htaccess. This improves security by preventing sensitive configuration files from being accessed via the web.

# wordpress
pm = dynamic: Scales the number of PHP worker processes automatically based on traffic demand. It’s efficient, flexible, and helps handle variable web traffic without wasting resources.
It’s the most common setting for websites that experience fluctuating traffic, such as WordPress sites or e-commerce platforms.
By using pm = dynamic, PHP-FPM ensures that resources are allocated optimally, scaling up when traffic increases and scaling down when it's not needed.

pm = dynamic
pm.max_children = 50          # Max number of PHP processes
pm.start_servers = 5          # Number of PHP processes to start initially
pm.min_spare_servers = 5      # Keep at least 5 idle PHP processes
pm.max_spare_servers = 35     # Don't allow more than 35 idle PHP processes


In the context of PHP-FPM and its process management, the term "idle" refers to PHP worker processes that are not currently handling any requests. These worker processes are "waiting" for new incoming requests from the web server, but they're not actively doing any work at the moment.

Idle Processes in PHP-FPM:
When PHP-FPM starts, it creates a number of worker processes based on the configuration (especially under pm = dynamic or pm = ondemand settings). These processes may be in one of two states:

Active: A worker process that is currently handling a request (i.e., processing PHP code).
Idle: A worker process that is not currently handling a request but is available to process the next incoming request.

Differences Between FastCGI and CGI:

      Feature                     CGI                                 FastCGI

Process Handling  | Spawns a new process per request     |    Uses persistent processes
Performance	      | Slower (high overhead)	             |    Faster (low overhead)
Resource Usage	  | High resource consumption	         |    More efficient resource usage
Scalability	      | Limited scalability                  |    Highly scalable
Communication	  | Uses stdin/stdout for communication	 |    Persistent connections for communication
Best for	      | Low-traffic websites	             |    High-traffic websites
Common Use	      | Older or simpler setups	             |    Modern web servers (Nginx, Apache)
