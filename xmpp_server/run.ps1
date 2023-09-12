docker build . --tag xmpp-local

docker stop xmpp *>$null
docker run --name xmpp --rm -p 5222:5222 -p 5280:5280 -e VIRTUAL_HOST=test xmpp-local
