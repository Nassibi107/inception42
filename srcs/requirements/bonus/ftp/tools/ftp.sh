#!/bin/sh

useradd -m $UFTP
echo "$UFTP:$PFTP" | chpasswd
mkdir -p /home/$UFTP/ftp/upload
mkdir -p /var/run/vsftpd/empty
chown nobody:nogroup /home/$UFTP/ftp/upload
chmod a-w /home/$UFTP/ftp
chmod 755 /home/$UFTP/ftp/upload
chmod 755 /var/run/vsftpd/empty 

vsftpd /etc/vsftpd.conf
