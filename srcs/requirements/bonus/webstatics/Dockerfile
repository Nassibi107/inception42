FROM debian:buster


ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && \
    apt install -y nodejs npm wget unzip git && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf /home/app

WORKDIR /home/app

COPY ./tools/web.sh /home/app/web.sh

RUN chmod +x web.sh

RUN bash web.sh && \
    rm web.sh

RUN npm init -y && \
    npm install express && \
    npm cache clean --force

EXPOSE 3000


CMD ["node", "run.js"]
