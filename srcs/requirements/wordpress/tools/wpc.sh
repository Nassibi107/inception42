#!/bin/sh

# Function to check if a command exists and run it
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check required environment variables
check_env_vars() {
  if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_HOSTNAME" ] || [ -z "$MYSQL_DATABASE" ] || [ -z "$DNS_LOCAL" ]; then
    echo "Error: Required environment variables are missing."
    exit 1
  fi
}

# Function to download and extract WordPress
download_wordpress() {
  echo "Downloading and extracting WordPress..."
  wget -q http://wordpress.org/latest.tar.gz
  if [ $? -ne 0 ]; then
    echo "Error: Failed to download WordPress."
    exit 1
  fi

  tar -xzf latest.tar.gz
  if [ $? -ne 0 ]; then
    echo "Error: Failed to extract WordPress."
    exit 1
  fi

  mv wordpress/* .
  rm -rf latest.tar.gz wordpress
}

# Function to configure wp-config.php with environment variables
configure_wp_config() {
  echo "Configuring wp-config.php..."

  # Replace placeholders in wp-config-sample.php with environment variables
  sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
  sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
  sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
  sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php

  # Rename the sample to wp-config.php
  cp wp-config-sample.php wp-config.php
}

# Function to configure Redis settings in WordPress
# configure_redis() {
#   echo "Configuring Redis settings..."

#   wp config set WP_REDIS_HOST redis --allow-root
#   wp config set WP_REDIS_PORT 6379 --raw --allow-root
#   wp config set WP_CACHE_KEY_SALT $DNS_LOCAL --allow-root
#   wp config set WP_REDIS_CLIENT phpredis --allow-root

#   # Install and activate Redis cache plugin
#   wp plugin install redis-cache --activate --allow-root
#   wp plugin update --all --allow-root
#   wp redis enable --allow-root
# }

# Function to install WordPress core (create database tables)
install_wordpress() {
  echo "Installing WordPress core..."
  
  # Run wp core install to initialize WordPress
  wp core install --url="$DNS_LOCAL" --title="insptions" \
    --admin_user="admin" --admin_password="admin_password" \
    --admin_email="admin@example.com" --allow-root
  if [ $? -ne 0 ]; then
    echo "Error: Failed to install WordPress."
    exit 1
  fi
}

# Main script execution

# Check if environment variables are set
check_env_vars

# Check if wp-config.php already exists
if [ -f ./wp-config.php ]; then
  echo "WordPress is already downloaded and configured."
else
  # Mandatory part: Download WordPress and configure wp-config.php
  download_wordpress
  configure_wp_config

  # Optional bonus part: Redis configuration
  # configure_redis
fi

# Install WordPress core (run this after wp-config.php is set up)
install_wordpress


# Execute the command passed to the script
exec "$@"
