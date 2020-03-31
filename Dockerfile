FROM alpine:latest AS alpine-chrome

# Installs latest Chromium package.
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community > /etc/apk/repositories
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories

RUN apk add --no-cache \
  libstdc++@edge \
  chromium@edge \
  harfbuzz@edge \
  nss@edge \
  freetype@edge \
  ttf-freefont@edge

RUN rm -rf /var/cache/*

RUN mkdir /var/cache/apk

# Add Chrome as a user
RUN mkdir -p /usr/src/app

RUN adduser -D chrome
RUN chown -R chrome:chrome /usr/src/app

# Run Chrome as non-privileged
USER chrome
WORKDIR /usr/src/app

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

# Autorun chrome headless with no GPU
ENTRYPOINT ["chromium-browser", "--headless", "--disable-gpu", "--disable-software-rasterizer", "--disable-dev-shm-usage"]

##############################################################################################################

FROM alpine-chrome

USER root

RUN apk add --no-cache \
  tini@edge \
  git@edge \
  nodejs@edge \
  nodejs-npm@edge

RUN rm -rf /var/lib/apt/lists/* /var/cache/apk/* /usr/share/man /tmp/*

ENTRYPOINT ["tini", "--"]
