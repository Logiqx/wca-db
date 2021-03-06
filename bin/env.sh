PROJ_DIR=$(realpath $(dirname $0)/..)
PROJ_NAME=$(basename $PROJ_DIR)
WORK_DIR=/home/jovyan/work/$PROJ_NAME

run_py_script()
{
  docker run -it --rm \
         --mount type=bind,src=$(realpath $PROJ_DIR/docker/mysql/.my.cnf),dst=/home/jovyan/.my.cnf \
         -e MYSQL_DATABASE=${MYSQL_DATABASE:-wca} \
         -e MYSQL_USER=${MYSQL_USER:-wca} \
         --network=wca_default ${PROJ_NAME}:${IMAGE_TAG:-latest} python/$1
}

# Explanation at https://www.peterbe.com/plog/set-ex
set -ex

cd $PROJ_DIR
