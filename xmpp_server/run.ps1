docker build . --tag xmpp-config
docker run --name xmpp --rm -p 5222:5222 -p 5280:5280 -e VIRTUAL_HOST=x xmpp-config
