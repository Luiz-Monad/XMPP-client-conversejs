docker build . --tag xmpp-config
docker tag xmpp-config multizap.azurecr.io/xmpp
docker image push multizap.azurecr.io/xmpp
