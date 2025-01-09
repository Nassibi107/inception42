FROM debian:bullseye-slim

# Set environment variable for PHP build dependencies
ENV PHPIZE_DEPS="autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c libssl-dev php-pear php-dev"

# Install PHP and required extensions
RUN apt-get update && apt-get install -y \
    php8.0-cli \
    php8.0-fpm \
    php8.0-dom \
    php8.0-ftp \
    php8.0-gd \
    php8.0-openssl \
    php8.0-phar \
    php8.0-iconv \
    php8.0-mbstring \
    php8.0-mysqli \
    php8.0-tokenizer \
    php8.0-zlib \
    mariadb-client \
    $PHPIZE_DEPS \
    && pecl install redis \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove $PHPIZE_DEPS

# Create a symlink for php-fpm8
RUN ln -s /usr/sbin/php-fpm8.0 /usr/sbin/php-fpm

# Install WP CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /tmp/wp-cli.phar \
    && mv /tmp/wp-cli.phar /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

# Copy custom configurations and scripts
COPY conf/www.conf /etc/php/8.0/fpm/pool.d/www.conf
COPY tools/wpc.sh /usr/local/bin/

# Expose the PHP-FPM port
EXPOSE 9000
# Set entrypoint and command
ENTRYPOINT ["sh", "/usr/local/bin/wpc.sh"]
CMD ["php-fpm", "-F"]
