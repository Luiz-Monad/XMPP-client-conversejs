docker build . --tag xmpp-local
docker run --name server --rm -p 3333:3333 xmpp-local
