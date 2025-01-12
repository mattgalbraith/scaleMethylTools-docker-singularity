################# BASE IMAGE ######################
FROM --platform=linux/amd64 mambaorg/micromamba:1.5.10-noble
# Micromamba for fast building of small conda-based containers.
# https://github.com/mamba-org/micromamba-docker
# The 'base' conda environment is automatically activated when the image is running.

################## METADATA ######################
LABEL base_image="mambaorg/micromamba:1.3.1-focal"
LABEL version="0.1"
LABEL software="scaleMethylTools"
LABEL software.version=""
LABEL about.summary="Dependencies for ScaleBio Methylation Nextflow Workflow"
LABEL about.home="https://github.com/ScaleBio/ScaleMethyl"
LABEL about.documentation=""
LABEL about.license_file=""
LABEL about.license=""

################## MAINTAINER ######################
MAINTAINER Matthew Galbraith <matthew.galbraith@cuanschutz.edu>

################## INSTALLATION ######################
ENV DEBIAN_FRONTEND=noninteractive
ENV PACKAGES="tar wget ca-certificates"

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# USER mambauser

# Copy the yaml file to your docker image and pass it to micromamba
COPY --chown=$MAMBA_USER:$MAMBA_USER scaleMethylTools.conda.yml /tmp/scaleMethylTools.conda.yml
RUN micromamba install -y -n base -f /tmp/scaleMethylTools.conda.yml && \
    micromamba clean --all --yes
# ENV PATH="/opt/conda/envs/scaleMethylTools/bin:${PATH}" # not needed if installing to base env?

COPY --chown=$MAMBA_USER:$MAMBA_USER download-scale-tools.sh /tmp/download-scale-tools.sh
RUN mkdir /tools && sh /tmp/download-scale-tools.sh /tools

USER mambauser
WORKDIR /
ENV PATH="/tools:${PATH}"