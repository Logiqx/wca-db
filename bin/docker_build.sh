set -ex

# Project Env
. $(dirname $0)/env.sh
cd $PROJ_DIR

# Determine Tag
IMAGE_NAME=$PROJ_NAME
IMAGE_TAG=$(git rev-parse --short=12 HEAD)

# Docker Build
DOCKER_BUILDKIT=1 docker build . -t $IMAGE_NAME:$IMAGE_TAG

# Download Database
time run_py_script Download_Results.py

# Docker Tag
docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest
