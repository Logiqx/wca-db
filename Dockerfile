# Base image versions
ARG NOTEBOOK_VERSION=c39518a3252f
ARG PYTHON_VERSION=3.8
ARG ALPINE_VERSION=3.10

# Jupyter notebook image is used as the builder
FROM jupyter/base-notebook:${NOTEBOOK_VERSION} AS builder

# Copy the required project files
WORKDIR /home/jovyan/work/wca-db
COPY --chown=jovyan:users python/*.*py* ./python/
COPY --chown=jovyan:users sql/*.sql ./sql/

# Convert Jupyter notebooks to regular Python scripts
RUN jupyter nbconvert --to python python/*.ipynb && \
    rm python/*.ipynb

# Ensure project file permissions are correct
RUN chmod 755 python/*.py && \
    chmod 644 sql/*.sql

# Create final image from Python 3 + Beautiful Soup 4 on Alpine Linux
FROM logiqx/python-bs4:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

# Install MySQL client
RUN apk add --no-cache mysql-client=~10.3

# Note: Jovian is a fictional native inhabitant of the planet Jupiter
ARG PY_USER=jovyan
ARG PY_GROUP=jovyan
ARG PY_UID=1000
ARG PY_GID=1000

# Create the Python user and work directory
RUN addgroup -g ${PY_GID} ${PY_GROUP} && \
    adduser -u ${PY_UID} --disabled-password ${PY_USER} -G ${PY_GROUP} && \
    mkdir -p /home/${PY_USER}/work && \
    chown ${PY_USER} /home/${PY_USER}/work

# Environment variables used by the Python scripts
ENV MYSQL_HOSTNAME=mariadb
ENV MYSQL_DATABASE=wca
ENV MYSQL_USER=wca

# Copy project files from the builder
USER ${PY_USER}
WORKDIR /home/${PY_USER}/work
COPY --from=builder --chown=jovyan:jovyan /home/jovyan/work/ ./

# Define the command / entrypoint
CMD ["python3"]
