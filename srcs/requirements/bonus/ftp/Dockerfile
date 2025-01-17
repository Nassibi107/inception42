FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt-get install -y vsftpd

COPY ./conf/vsftpd.conf /etc/vsftpd.conf
COPY ./tools/ftp.sh /

ENTRYPOINT ["sh", "/ftp.sh"]