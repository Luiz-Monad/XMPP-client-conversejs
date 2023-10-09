#!/bin/sh

python3 $DIR/template.py $DIR/login.template $DIR/wwwroot/login.html
exec node "server.js" "$@"
