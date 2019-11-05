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

ENV LOG_ROOT=/var/log/app
RUN mkdir -p ${LOG_ROOT}
RUN chown -R ubuntu ${LOG_ROOT}

ENV APP_ROOT=/env/app
ENV APP_HOME=${APP_ROOT}/node_modules/@nebulario/microservice-certificates

RUN mkdir -p ${APP_HOME}
RUN chown -R ubuntu ${APP_HOME}

USER ubuntu

ARG CACHEBUST=1
RUN echo "CACHE $CACHEBUST"

COPY --chown=ubuntu:ubuntu ./node_modules /env/app/node_modules

WORKDIR ${APP_HOME}
ENTRYPOINT ["node"]
CMD ["dist/index.js"]
