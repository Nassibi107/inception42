#!/bin/sh

echo "Installing PHP, PHP-MySQL, and wget..."
apt update &&  apt install php php-mysql wget -y

echo "Downloading Adminer..."
if wget "$ADMINER_URL" -O "$ADMINER_FILE"; then
    echo "Adminer downloaded successfully."
else
    echo "Failed to download Adminer. Exiting."
    exit 1
fi

echo "Setting ownership and permissions..."
 chown -R www-data:www-data "$ADMINER_FILE"
 chmod 755 "$ADMINER_FILE"
echo "Removing default index.html if exists..."
if [ -f "$WWW_DIR/index.html" ]; then
     rm -f "$WWW_DIR/index.html"
    echo "index.html removed."
else
    echo "No index.html file to remove."
fi

echo "Starting PHP built-in server on port $PORT..."
cd "$WWW_DIR" || { echo "Failed to access $WWW_DIR"; exit 1; }
php -S 0.0.0.0:"$PORT" "$ADMINER_FILE"