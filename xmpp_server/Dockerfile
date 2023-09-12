FROM ejabberd/ecs
# https://github.com/processone/docker-ejabberd/blob/master/ecs/Dockerfile

USER root
RUN apk update && apk add --no-cache python3

RUN chown ejabberd:ejabberd /home/ejabberd/conf
USER ejabberd

WORKDIR /home/ejabberd/conf

ARG LOG_LEVEL=4
ARG ADMIN_USER=admin
ARG ADMIN_PW=admin

ENV LOG_LEVEL $LOG_LEVEL
ENV ADMIN_USER $ADMIN_USER
ENV ADMIN_PW $ADMIN_PW

COPY ejabberd.yml ./ejabberd.template
COPY template.py .
COPY start.sh .

EXPOSE 5280
ENTRYPOINT ["/sbin/tini", "--", "/home/ejabberd/conf/start.sh"]
CMD ["foreground"]
