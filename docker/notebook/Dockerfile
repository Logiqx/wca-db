ARG NOTEBOOK_VERSION
FROM jupyter/base-notebook:${NOTEBOOK_VERSION:-latest}

# Ideally apt-get would use sudo but it requires the jovyan password
USER root

# Check for latest packages
RUN apt-get update

# Do a full installation of gcc including recommended packages
RUN apt-get install -y gcc

# Intentionally exclude the typical cleanup of "rm -rf /var/lib/apt/lists/*"
RUN apt-get install -y --no-install-recommends mysql-client

# Switch back to the normal user
USER jovyan

# Note that xlrd 1.2.* is required for .xlsx support (dropped in xlrd 2.0.0)
RUN pip install --no-cache-dir \
    beautifulsoup4==4.9.* \
    google==2.0.* \
    lxml==4.6.* \
    matplotlib==3.3.* \
    numpy==1.20.* \
    PyMySQL==1.0.* \
    python-Levenshtein==0.12.* \
    scipy==1.6.* \
    sqlparse==0.4.* \
    xlrd==1.2.*
