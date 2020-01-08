###############################################
## An SV calling Docker container for WG(B)S ##
###############################################

# Base image is ubuntu
FROM ubuntu:latest

# Author/maintainer
MAINTAINER Benjamin K. Johnson

# Usual update and installation of things
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -qy wget curl git bzip2 ca-certificates procps zlib1g-dev \
    make build-essential cmake libncurses-dev ncurses-dev g++ gcc \
    nfs-common pigz parallel bedtools gawk fuse mdadm time \
    libbz2-dev lzma-dev liblzma-dev libglib2.0-0 libxext6 libsm6 libxrender1 \
    syslog-ng libssl-dev libtool autoconf automake \
    libcurl4-openssl-dev libffi-dev libblas-dev liblapack-dev \
    libatlas-base-dev parallel default-jre

#install miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

#install some base tooling
RUN conda install -y -c bioconda bcftools samtools samblaster

#build smoove
#this requires some finessing of the tooling
RUN conda create -n smoove-env -c conda-forge -c bioconda python=2.7 awscli numpy scipy cython pysam toolshed pyvcf pyfaidx cyvcf2 svtyper=0.7.1 svtools=0.5.1 gsort
RUN echo "source activate smoove-env" > ~/.bashrc
ENV PATH /opt/conda/envs/smoove-env/bin:$PATH
ENV HTSLIB_LIBRARY_DIR /usr/local/lib
ENV HTSLIB_INCLUDE_DIR /usr/local/include
ENV LD_LIBRARY_PATH /usr/local/lib

#finish building smoove and manta and add biscuit for alignment
COPY ./docker-build.sh .
RUN bash docker-build.sh
#make some aliases for manta since the command/file tree is insane
RUN echo "alias manta_config='python /usr/local/bin/manta/bin/configManta.py'" >> ~/.bashrc
#GRIDSS tool to alias
RUN echo "alias clip2split='java -cp /gridss/gridss-2.7.3-gridss-jar-with-dependencies.jar gridss.SoftClipsToSplitReads'" >> ~/.bashrc
WORKDIR /work/

##OPTIONAL
#download references
#RUN mkdir -p /work/references/hg38 /work/references/hg19 /work/references/mm9 /work/references/mm10
#RUN cd /work/references/hg38 && mkdir biscuit bwa fasta
#get the fasta references
#RUN cd /work/references/hg38/fasta && wget -q https://file.ac/21euCO1oZvBr5DSj-OV1KQ/hg38/fasta/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna \
#&& wget -q https://file.ac/21euCO1oZvBr5DSj-OV1KQ/hg38/fasta/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.fai
#get the biscuit indexes
#hg38
#RUN cd /work/references/hg38/biscuit \
#&& wget -q https://file.ac/21euCO1oZvBr5DSj-OV1KQ/hg38/biscuit/biscuit_hg38_noalt.bis.amb \
#&& wget -q https://file.ac/21euCO1oZvBr5DSj-OV1KQ/hg38/biscuit/biscuit_hg38_noalt.bis.ann \
#&& wget -q https://file.ac/21euCO1oZvBr5DSj-OV1KQ/hg38/biscuit/biscuit_hg38_noalt.bis.pac \
#&& wget -q https://file.ac/21euCO1oZvBr5DSj-OV1KQ/hg38/biscuit/biscuit_hg38_noalt.dau.bwt \
#&& wget -q https://file.ac/21euCO1oZvBr5DSj-OV1KQ/hg38/biscuit/biscuit_hg38_noalt.dau.sa \
#&& wget -q https://file.ac/21euCO1oZvBr5DSj-OV1KQ/hg38/biscuit/biscuit_hg38_noalt.par.bwt \
#&& wget -q https://file.ac/21euCO1oZvBr5DSj-OV1KQ/hg38/biscuit/biscuit_hg38_noalt.par.sa
#get the bwa indexes
#hg38
#RUN cd /work/references/hg38/bwa \
#&& wget -q https://file.ac/21euCO1oZvBr5DSj-OV1KQ/hg38/bwa/bwa_hg38_noalt.amb \
#&& wget -q https://file.ac/21euCO1oZvBr5DSj-OV1KQ/hg38/bwa/bwa_hg38_noalt.ann \
#&& wget -q https://file.ac/21euCO1oZvBr5DSj-OV1KQ/hg38/bwa/bwa_hg38_noalt.bwt \
#&& wget -q https://file.ac/21euCO1oZvBr5DSj-OV1KQ/hg38/bwa/bwa_hg38_noalt.pac \
#&& wget -q https://file.ac/21euCO1oZvBr5DSj-OV1KQ/hg38/bwa/bwa_hg38_noalt.sa
