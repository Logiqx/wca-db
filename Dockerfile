# Base image versions
ARG NOTEBOOK_VERSION=c39518a3252f
ARG PYTHON_VERSION=3.7
ARG ALPINE_VERSION=3.10

# Jupter notebook image is used as the builder
FROM jupyter/base-notebook:${NOTEBOOK_VERSION} AS builder

# Environment variables
ENV NB_USER=jovyan
ENV PROJDIR=/home/${NB_USER}/work/wca-db

# Convert Jupter notebooks to regular Python scripts
RUN mkdir -p ${PROJDIR}/python
COPY python/*.ipynb ${PROJDIR}/python/
RUN jupyter nbconvert --to python ${PROJDIR}/python/Download_Database.ipynb && \
    chmod 755 ${PROJDIR}/python/*.py && \
    rm ${PROJDIR}/python/*.ipynb

# Copy the required SQL scripts
COPY sql/alter_tables.sql ${PROJDIR}/sql/
COPY sql/create_indices.sql ${PROJDIR}/sql/

# Create final image from Python (Alpine) + MySQL client
FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION}
RUN apk update && \
    apk add mysql-client

# Environment variables
ENV NB_USER=jovyan
ENV PROJDIR=/home/${NB_USER}/work/wca-db

# Create the Jupter user and project structure
RUN addgroup -S ${NB_USER} && adduser -S ${NB_USER} -G ${NB_USER}
USER ${NB_USER}
RUN mkdir -p ${PROJDIR}/python ${PROJDIR}/sql

# Copy project files - n.b. chown option does not support environment variables
COPY --from=builder --chown=jovyan:jovyan ${PROJDIR}/ ${PROJDIR}/

# Define the command / entrypoint
CMD ["python"]
