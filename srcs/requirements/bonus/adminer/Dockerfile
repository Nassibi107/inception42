
FROM debian:bullseye


RUN apt -y update 

COPY ./tools/setup.sh /

RUN chmod +x setup.sh
RUN
RUN apt install wget -y && apt install php php-mysql  -y

EXPOSE 9000
STOPSIGNAL SIGQUIT


CMD ["setup.sh"]
