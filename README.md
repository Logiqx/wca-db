# wca-db

This project includes a number of scripts to download and optimise the WCA results [export](https://www.worldcubeassociation.org/results/misc/export.html).

It mainly consists of Python and SQL scripts but it also makes good use of Docker.



### MariaDB

[MariaDB](https://mariadb.org/) is being used as an alternative to [MySQL](https://www.mysql.com/) because it generally performs better for this project.

The MariaDB server is managed through Docker.



### Python

[Jupyter Notebook](https://jupyter.org/) is used to develop and test the Python code.

The Jupyter Notebook server is managed through Docker.



### Docker

[Docker](https://www.docker.com/) is used to manage the MariaDB and Jupter Notebook servers with a common data folder.

I have produced detailed documented relating to the use of Docker in a separate [README](docker/README.md).

