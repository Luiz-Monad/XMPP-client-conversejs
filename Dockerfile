FROM node:19-alpine as base

# Create app directory
WORKDIR /build

# Install app dependencies
COPY package*.json ./
RUN npm install

# Build

COPY ./images ./images
COPY ./logo ./logo
COPY ./sounds ./sounds
COPY ./src ./src
COPY ./webpack ./webpack
COPY babel.* .
COPY tsconfig.json .
COPY postcss.config.js .

RUN npm run build
COPY ./3rdparty ./dist

# ------------------------------------------------------------------------

FROM node:19-alpine as base-static

# Create node directory
WORKDIR /build/static

# Install node dependencies
COPY ./static_server/package*.json ./
RUN npm install

# Build static-server
COPY ./static_server .
RUN npm run build

# ------------------------------------------------------------------------

FROM node:19-alpine

USER root
RUN apk update && apk add --no-cache python3 tini
USER node

ARG DIR=/home/node/app
ARG PORT=8000

ENV DIR $DIR
ENV PORT $PORT
ENV XMPP_SERVER ws://xmpp:5280/ws

WORKDIR $DIR

COPY --from=base "/build/dist" "./wwwroot"
COPY --from=base-static "/build/dist/static_server" "."
COPY --from=base-static "/build/static/node_modules" "./node_modules"

USER root
RUN chown node:node $DIR/wwwroot
USER node

COPY ./static_server/index.html ./index.template
COPY ./static_server/template.py .
RUN python3 template.py index.template wwwroot/index.html

EXPOSE $PORT
ENTRYPOINT ["/sbin/tini", "--", "node", "server.js"]
