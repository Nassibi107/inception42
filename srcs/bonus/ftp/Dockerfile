FROM debian:bullseye-slim

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

COPY tools/ftp.sh /usr/local/bin/ftp.sh
COPY conf/vsftpd.conf /etc/vsftpd.conf

RUN chmod +x /usr/local/bin/server_ftp.sh

EXPOSE 21

ENTRYPOINT ["sh", "/usr/local/bin/server_ftp.sh"]
