#!/bin/sh

J=/home/ejabberd
CTL_ON_CREATE=register $ADMIN_USER messenger $ADMIN_PW

python3 $J/conf/template.py $J/conf/ejabberd.template $J/conf/ejabberd.yml
exec $J/bin/ejabberdctl "$@"
