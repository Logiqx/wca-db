# Project Env
. $(dirname $0)/env.sh

# Explanation at https://www.peterbe.com/plog/set-ex
set -ex

# Determine Tag
IMAGE_NAME=$PROJ_NAME
IMAGE_TAG=$(git rev-parse --short=12 HEAD)

# Docker Build
DOCKER_BUILDKIT=1 docker build . -t $IMAGE_NAME:$IMAGE_TAG

# Download Database
time run_py_script Download_Results.py

# Docker Tag
docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest
