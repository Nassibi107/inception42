FROM debian:bullseye


RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    mariadb-server wget mycli && \
    apt-get clean && rm -rf /var/lib/apt/lists/* 


COPY tools/mysql_dbConf.sh /mysql_dbConf.sh

RUN chmod +x /mysql_dbConf.sh

EXPOSE 3306


ENTRYPOINT ["/mysql_dbConf.sh"]
