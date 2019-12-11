# Jenkins

Jenkins is used by this project for CI/CD and scheduled batch jobs.

Rather than describe all of the jobs in great detail this document will simply list the dependencies.



## wca-db-download-results

This job downloads the results database and has the following dependencies:

- wca-db-download-results
  - *Schedule 10 4 \* \* \**
  - wca-db-docker-build
    - *GitHub trigger on wca-db repository*

To set up Jenkins the jobs should be created and run in the following order:

1. wca-db-docker-build
2. wca-db-download-results

