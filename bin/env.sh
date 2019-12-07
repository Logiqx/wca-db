export PROJ_DIR=$(realpath $(dirname $0)/..)
export PROJ_NAME=$(basename $PROJ_DIR)
export WORK_DIR=/home/jovyan/work/$PROJ_NAME

run_py_script()
{
  echo "Running $1..."
  docker run -it --rm \
         --mount type=bind,src=$(realpath $PROJ_DIR/docker/mysql/.my.cnf),dst=/home/jovyan/.my.cnf \
         --network=wca_default -w $WORK_DIR/python $PROJ_NAME ./$1
}