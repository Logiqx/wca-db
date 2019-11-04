# Base image versions
ARG NOTEBOOK_VERSION=c39518a3252f
ARG PYTHON_VERSION=3.8
ARG ALPINE_VERSION=3.10

# Jupter notebook image is used as the builder
FROM jupyter/base-notebook:${NOTEBOOK_VERSION} AS builder

# Environment variables
ENV NB_USER=jovyan
ENV PROJDIR=/home/${NB_USER}/work/wca-db

# Convert Jupter notebooks to regular Python scripts
COPY --chown=jovyan:users python/*.ipynb ${PROJDIR}/python/
RUN jupyter nbconvert --to python ${PROJDIR}/python/*.ipynb && \
    chmod 755 ${PROJDIR}/python/*.py && \
    rm ${PROJDIR}/python/*.ipynb

# Copy the required SQL scripts
COPY --chown=jovyan:users sql/*.sql ${PROJDIR}/sql/
RUN chmod 644 ${PROJDIR}/sql/*.sql

# Create final image from Python 3 + Beautiful Soup 4 on Alpine Linux
FROM logiqx/python-bs4:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

# Install MySQL client
RUN apk update && \
    apk add --no-cache mysql-client

# Install AWS CLI
RUN pip install --no-cache-dir awscli

# Environment variables
ENV NB_USER=jovyan
ENV PROJDIR=/home/${NB_USER}/work/wca-db

# Create the notebook user and project structure
RUN addgroup -g 1000 -S ${NB_USER} && \
    adduser -u 1000 -S ${NB_USER} -G ${NB_USER}
USER ${NB_USER}

# Copy project files
COPY --from=builder --chown=jovyan:jovyan ${PROJDIR}/ ${PROJDIR}/

# Define the command / entrypoint
CMD ["python3"]
