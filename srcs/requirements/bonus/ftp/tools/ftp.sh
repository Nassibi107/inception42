#!/bin/sh

# Ensure the /etc/vsftpd directory and user list exist
mkdir -p /etc/vsftpd
touch /etc/vsftpd.userlist

# Create the secure chroot directory
mkdir -p /var/run/vsftpd/empty

# Check if the backup configuration file exists
if [ ! -f "/etc/vsftpd/vsftpd.conf.bak" ]; then
    echo "Initializing FTP server configuration..."

    # Ensure the target directory exists
    mkdir -p /var/www/html

    # Backup the default vsftpd configuration and replace it with the custom one
    cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak
    mv /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf

    # Add the FTP user, set their password, and assign ownership of the target directory
    if ! id "$FTP_USR" &> /dev/null; then
        adduser "$FTP_USR" --disabled-password --gecos ""
        echo "$FTP_USR:$FTP_PWD" | /usr/sbin/chpasswd
    else
        echo "User $FTP_USR already exists. Skipping user creation."
    fi

    # Set ownership and permissions for the FTP directory
    chown -R "$FTP_USR:$FTP_USR" /var/www/html
    chmod -R 755 /var/www/html

    # Add the user to the vsftpd user list if not already added
    grep -qx "$FTP_USR" /etc/vsftpd.userlist || echo "$FTP_USR" >> /etc/vsftpd.userlist

    echo "FTP server configuration initialized."
fi

echo "Starting FTP server on port 21..."
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
