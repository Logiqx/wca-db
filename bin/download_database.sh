# --mount type=bind,src=/c/Projects/WCA/wca-db/data,dst=/home/jovyan/wca-db/data \

time docker run -it --rm \
         --mount type=bind,src=/c/Projects/WCA/wca-db/docker/mysql/.my.cnf,dst=/home/jovyan/.my.cnf \
         --network=wca_default -w /home/jovyan/work/wca-db/python wca-db ./Download_Database.py
