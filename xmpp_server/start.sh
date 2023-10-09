#!/bin/sh

export CTL_ON_CREATE="register $ADMIN_USER $VHOST $ADMIN_PW"

python3 $DIR/template.py $DIR/ejabberd.template $DIR/conf/ejabberd.yml
exec $DIR/bin/ejabberdctl "$@"
