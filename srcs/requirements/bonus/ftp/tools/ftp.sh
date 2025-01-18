#!/bin/bash


service vsftpd start

# Add the USER, change his password and declare him as the owner of wordpress folder and all subfolders

adduser $UFTP --disabled-password

echo "$UFTP:$PFTP" | /usr/sbin/chpasswd

echo "$UFTP" | tee -a /etc/vsftpd.userlist 


mkdir /home/$UFTP/ftp


chown nobody:nogroup /home/$UFTP/ftp
chmod a-w /home/$UFTP/ftp

mkdir /home/$UFTP/ftp/files
chown $UFTP:$UFTP /home/$UFTP/ftp/files

sed -i -r "s/#write_enable=YES/write_enable=YES/1"   /etc/vsftpd.conf
sed -i -r "s/#chroot_local_user=YES/chroot_local_user=YES/1"   /etc/vsftpd.conf

service vsftpd stop


/usr/sbin/vsftpd