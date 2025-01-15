FROM debian:bullseye-slim

# Install vsftpd and create necessary directories
RUN apt-get update && apt-get install -y \
    vsftpd \
    && mkdir -p /etc/vsftpd \
    && touch /etc/vsftpd.userlist \
    && rm -rf /var/lib/apt/lists/*

# Create the vsftpd.conf file with the basic configuration
COPY /conf/vsftpd.conf  /etc/vsftpd/vsftpd.conf

# Copy your ftp.sh and any other necessary files
COPY tools/ftp.sh /usr/local/bin/ftp.sh
COPY conf/vsftpd.conf /tmp/vsftpd.conf

RUN chmod +x /usr/local/bin/ftp.sh

EXPOSE 21

ENTRYPOINT ["sh", "/usr/local/bin/ftp.sh"]
