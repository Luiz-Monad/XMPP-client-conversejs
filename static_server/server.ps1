$env:NODE_PATH=(gi ./node_modules).FullName 
$env:PORT=3003
node ../dist/static_server/server.js
