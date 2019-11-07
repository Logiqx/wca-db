DOCKER_BUILDKIT=1 docker build . -t wca-db:$(git rev-parse --short=12 HEAD)
docker tag wca-db:$(git rev-parse --short=12 HEAD) wca-db:latest
