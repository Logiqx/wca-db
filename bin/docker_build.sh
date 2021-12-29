# Project Env
. $(dirname $0)/env.sh

# Determine Tag
IMAGE_NAME=$PROJ_NAME
IMAGE_TAG=$(git rev-parse --short=12 HEAD)

# Docker Build
DOCKER_BUILDKIT=1 docker build . -f Dockerfile -t $IMAGE_NAME:$IMAGE_TAG

# Test database
MYSQL_DATABASE=wca_tst
MYSQL_USER=wca_tst

# Download Database
run_py_script Download_Results.py

# Docker Tag
docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest
