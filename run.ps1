docker build . --target base
docker build . --target base-static
docker build . --tag frontend-local

docker stop client *>$null
docker run --name client --rm -p 8000:8000 -e PORT=8000 frontend-local
