export PROJ_DIR=$(realpath $(dirname $0)/..)
export PROJ_NAME=$(basename $PROJ_DIR)
export WORK_DIR=/home/jovyan/work/$PROJ_NAME

run_py_script()
{
  IMAGE_NAME=${PROJ_NAME}
  IMAGE_TAG=${IMAGE_TAG:-latest}

  echo "Running $1..."
  docker run -it --rm \
         --mount type=bind,src=$(realpath $PROJ_DIR/docker/mysql/.my.cnf),dst=/home/jovyan/.my.cnf \
         --network=wca_default -w $WORK_DIR/python $IMAGE_NAME:$IMAGE_TAG ./$1
}

cd $PROJ_DIR
