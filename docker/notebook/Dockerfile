ARG NOTEBOOK_VERSION
FROM jupyter/base-notebook:${NOTEBOOK_VERSION:-latest}

RUN pip install --no-cache-dir beautifulsoup4==4.8.* lxml==4.4.* sqlparse==0.3.* PyMySQL==0.9.* google==2.0.*

# Ideally apt-get would use sudo but it requires the jovyan password
USER root
RUN apt-get update && apt-get install -y --no-install-recommends mysql-client
USER jovyan
