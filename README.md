[![Docker Image CI](https://github.com/mattgalbraith/scaleMethylTools-docker-singularity/actions/workflows/docker-image.yml/badge.svg)](https://github.com/mattgalbraith/scaleMethylTools-docker-singularity/actions/workflows/docker-image.yml)

# scaleMethylTools-docker-singularity

## Build Docker container and (optionally) convert to Apptainer/Singularity.  

Dependencies for ScaleBio Methylation Nextflow Workflow  
  - python=3.10.12
  - pip
  - bedtools=2.30.0
  - fastqc=0.12.1
  - multiqc=1.14
  - samtools=1.15
  - cutadapt=4.8
  - numpy=1.25.1
  - scipy=1.9.2
  - pandas=1.5.3
  - polars=0.20.18
  - pyarrow=16.1.0
  - python-duckdb=0.10.1
  - h5py=3.11.0
  - pybedtools=0.10.0
  - pysam=0.22.1
  - datapane=0.17.0
  - python-kaleido=0.2.1
  - matplotlib=3.7.2
  - plotly=5.15.0
  - seaborn=0.12.2
  - urllib3=1.26.14
  - pip:
    - bsbolt==1.5.0
  
  
#### Requirements:
N/A  
  
## Build docker container:  

### 1. For installation instructions: 
https://github.com/ScaleBio/ScaleMethyl/blob/main/README.md  
Micromamba-based Dockerfile adapted from:  
https://github.com/ScaleBio/ScaleMethyl/tree/main/envs  


### 2. Build the Docker Image

#### To build image from the command line:  
``` bash
# Assumes current working directory is the top-level <tool>-docker-singularity directory
docker build -t scale_methyl_tools:0.1 . # tag should match software version
```
* Can do this on [Google shell](https://shell.cloud.google.com)

#### To test this tool from the command line:
``` bash
docker run --rm -it scale_methyl_tools:0.1 fastqc --help 
docker run --rm -it scale_methyl_tools:0.1 cutadapt --help 
docker run --rm -it scale_methyl_tools:0.1 bc_parser --help 
docker run --rm -it scale_methyl_tools:0.1 sc_dedup --help 
```

## Optional: Conversion of Docker image to Singularity  

### 3. Build a Docker image to run Singularity  
(skip if this image is already on your system)  
https://github.com/mattgalbraith/singularity-docker

### 4. Save Docker image as tar and convert to sif (using singularity run from Docker container)  
``` bash
docker images
docker save <Image_ID> -o scale_methyl_tools0.1-docker.tar && gzip scale_methyl_tools0.1-docker.tar # = IMAGE_ID of <tool> image
docker run -v "$PWD":/data --rm -it singularity:1.3.2 bash -c "singularity build /data/scale_methyl_tools0.1.sif docker-archive:///data/scale_methyl_tools0.1-docker.tar.gz"
```
NB: On Apple M1/M2 machines ensure Singularity image is built with x86_64 architecture or sif may get built with arm64  

Next, transfer the scale_methyl_tools0.1.sif file to the system on which you want to run scale_methyl_tools from the Singularity container  

### 5. Test singularity container on (HPC) system with Singularity/Apptainer available  
``` bash
# set up path to the Singularity container
TOOL_SIF=path/to/scale_methyl_tools0.1.sif

# Test that <tool> can run from Singularity container
singularity run $TOOL_SIF fastqc --help # depending on system/version, singularity may be called apptainer
singularity run $TOOL_SIF cutadapt --help 
singularity run $TOOL_SIF bc_parser --help
singularity run $TOOL_SIF sc_dedup --help
```