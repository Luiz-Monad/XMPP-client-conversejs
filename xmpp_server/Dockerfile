FROM ejabberd/ecs
# https://github.com/processone/docker-ejabberd/blob/master/ecs/Dockerfile

USER root
RUN apk update && apk add --no-cache python3
USER ejabberd

ARG DIR=/home/ejabberd
ENV DIR $DIR
WORKDIR $DIR

USER root
RUN chown ejabberd:ejabberd $DIR/conf
USER ejabberd

COPY ejabberd.yml ./ejabberd.template
COPY template.py .
COPY start.sh .

ARG PORT=5280
ARG LOG_LEVEL=4
ARG ADMIN_USER=admin
ARG ADMIN_PW=admin
ARG VHOST=core

ENV PORT $PORT
ENV LOG_LEVEL $LOG_LEVEL
ENV ADMIN_USER $ADMIN_USER
ENV ADMIN_PW $ADMIN_PW
ENV VHOST $VHOST

EXPOSE $PORT
ENTRYPOINT ["/sbin/tini", "--", "/home/ejabberd/start.sh"]
CMD ["foreground"]
