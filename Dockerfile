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
ENV DIR $DIR
WORKDIR $DIR

COPY --from=base /build/dist ./wwwroot
COPY --from=base-static /build/dist/static_server .
COPY --from=base-static /build/static/node_modules ./node_modules
COPY --from=base-static /build/static/wwwroot ./wwwroot

COPY ./static_server/wwwroot/login.html ./login.template
COPY ./static_server/template.py .
COPY ./static_server/start.sh .

USER root
RUN chmod +x start.sh
RUN chown -R node:node $DIR
USER node

ARG PORT=8000

ENV PORT $PORT
ENV PROTECT_ROUTES false
ENV XMPP_SERVER ws://xmpp:5280/ws

EXPOSE $PORT
ENTRYPOINT ["/sbin/tini", "--", "/home/node/app/start.sh"]
CMD ["run"]
