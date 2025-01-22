FROM debian:buster


RUN apt update -y

RUN apt install vsftpd -y

COPY ./tools/ftp.sh /

RUN chmod +x ftp.sh 

COPY ./conf/vsftpd.conf /etc/vsftpd.conf


EXPOSE 21


CMD ["/ftp.sh"]
