#!/bin/sh

mkdir -p /etc/vsftpd
touch /etc/vsftpd.userlist

mkdir -p /var/run/vsftpd/empty


if [ ! -f "/etc/vsftpd/vsftpd.conf.bak" ]; then
    echo "Initializing FTP server configuration..."

    mkdir -p /var/www/html
    cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak
    mv /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf

    if ! id "$FTP_USR" &> /dev/null; then
        adduser "$FTP_USR" --disabled-password --gecos ""
        echo "$FTP_USR:$FTP_PWD" | /usr/sbin/chpasswd
    else
        echo "User $FTP_USR already exists. Skipping user creation."
    fi

    chown -R "$FTP_USR:$FTP_USR" /var/www/html
    chmod -R 755 /var/www/html

    grep -qx "$FTP_USR" /etc/vsftpd.userlist || echo "$FTP_USR" >> /etc/vsftpd.userlist

    echo "FTP server configuration initialized."
fi

echo "Starting FTP server on port 21..."
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
