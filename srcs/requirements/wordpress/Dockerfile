# Pull the base image
FROM debian:bullseye

# Update and upgrade the system, install required packages for PHP and WordPress CLI (wp)
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    php7.4-cli \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-mysqli \
    php7.4-redis \
    mariadb-client \
    && apt-get clean

# Install WP-CLI (WordPress CLI)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Ensure that necessary directories for PHP-FPM exist
RUN mkdir -p /run/php && \
    touch /run/php/php7.4-fpm.pid

# Copy custom PHP-FPM configuration and the wpc.sh script
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/wpc.sh /usr/local/bin/

# Expose the PHP-FPM port
EXPOSE 9000

# Set entrypoint and command
ENTRYPOINT ["sh", "/usr/local/bin/wpc.sh"]
CMD ["php-fpm7.4", "-F"]
