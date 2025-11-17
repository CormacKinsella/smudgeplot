# Global args
# FASTK: Release v1.1 + 12 unreleased commits (09/2025)
# smudgeplot: Skylight pre-release
ARG fastk_commit_id=0e24fb45b71c4e14382ae1e1bc063bf66ea4e112
ARG smudgeplot_commit_id=2a8dc5073aab309960e4e25d8b383292d5a186ce
ARG python_version=3.12

FROM python:${python_version}-slim AS builder

ARG fastk_commit_id
ARG smudgeplot_commit_id

RUN apt-get update && apt-get -y install \
    build-essential \
    git \
    libz-dev \
    libbz2-dev \
    liblzma-dev \
    procps \
    libcurl4-openssl-dev

WORKDIR /opt

RUN git clone https://github.com/thegenemyers/FASTK.git fastk && \
    cd fastk && \
    git reset --hard ${fastk_commit_id} && \
    make all && \
    cp FastK Fastcp Fastmv Fastmerge Fastrm Haplex Histex Homex Logex Profex Symmex Tabex Vennex /usr/local/bin/

RUN git clone https://github.com/KamilSJaron/smudgeplot smudgeplot && \
    cd smudgeplot && \
    git fetch --all && \
    git reset --hard ${smudgeplot_commit_id} && \
    python -m pip install .

WORKDIR /