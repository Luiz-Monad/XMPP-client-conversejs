docker build . --tag xmpp-local
docker tag xmpp-local multizap.azurecr.io/xmpp-local
docker image push multizap.azurecr.io/xmpp-local
