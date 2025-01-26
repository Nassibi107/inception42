FROM debian:bullseye

RUN apt update -y && apt upgrade -y

COPY ./tools/setup.sh /

ENTRYPOINT ["sh", "/setup.sh"]