FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository universe
RUN add-apt-repository ppa:certbot/certbot
RUN apt-get update
RUN apt-get install -y \
net-tools inetutils-traceroute \
iputils-ping xinetd telnetd

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install certbot

RUN apt-get install -y python3-certbot-dns-route53

RUN apt-get -y install nodejs
RUN apt-get -y install yarn
RUN apt-get -y install curl

RUN groupadd -g 1000 ubuntu && \
    useradd -r -ms /bin/bash -u 1000 -g ubuntu ubuntu
USER ubuntu

ARG CACHEBUST=1
RUN echo "CACHE $CACHEBUST"

COPY --chown=ubuntu:ubuntu ./node_modules /env/app/node_modules

ENTRYPOINT ["node"]
CMD ["/env/app/node_modules/@nebulario/microservice-certificates/dist/index.js"]
