docker build . --tag xmpp-local

docker stop xmpp *>$null
docker run --name xmpp --rm `
    -p 5280:5280 `
    -e LOG_LEVEL=debug `
    -e VHOST=core `
    -e HOST=test `
    xmpp-local
