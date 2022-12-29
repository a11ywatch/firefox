FROM jlesage/baseimage-gui:alpine-3.17-v4.2.2 AS rustbuilder

WORKDIR /app

RUN apk upgrade --update-cache --available && \
	apk add gcc cmake make g++ openssl libressl-dev curl pkgconfig

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup update

COPY . .

RUN cargo install sozu
RUN cargo install --no-default-features --path .

FROM jlesage/firefox:v22.12.2

ARG FIREFOX_VERSION=108.0.1-r1

EXPOSE 5800 5900 6001 6002

USER root

RUN firefox -CreateProfile "headless /moz-headless" -headless
ADD user.js /moz-headless/

COPY --from=rustbuilder /root/.cargo/bin/sozu /usr/local/bin/sozu
COPY --from=rustbuilder /root/.cargo/bin/firefox_driver /usr/local/bin/firefox_driver
COPY ./config.toml ./docker-entrypoint.sh /

RUN apk upgrade  \
    && apk add \
    libc6-compat openssl libressl-dev tini curl && \
    rm -rf /var/cache/apk/*

RUN chmod +x /docker-entrypoint.sh

ENV REMOTE_ADDRESS=0.0.0.0
ENV CONTAINER_DEBUG=1
ENV KEEP_APP_RUNNING=1

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
