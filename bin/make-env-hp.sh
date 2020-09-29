#!/bin/bash
# Make the hodgepodge environment

set -Eeo pipefail

eval "$(conda shell.bash hook)"

set -v
CONDA_ENV=hp

conda remove -n "$CONDA_ENV" --all

conda create -y -n "$CONDA_ENV" \
    python=3.7 ipykernel \
    numpy scipy matplotlib pandas \
    networkx \
    statsmodels scikit-learn scikit-image \
    nltk spacy \
    pyarrow dask \
    numba \
    openmpi openmpi-mpicc mpi4py

set +v
conda activate "$CONDA_ENV"
set -v

conda install -y \
    pytorch torchtext torchvision cudatoolkit=10.1 captum -c pytorch

pip install \
    black pylint pyflakes pydocstyle pytest pytest-cov \
    click click-completion \
    logbook \
    tqdm \
    jinja2\
    pyyaml toml \
    bokeh seaborn altair \
    xlrd \
    glom \
    more-itertools \
    tensorboardx \
    future \
    pillow \
    graphviz pydot \
    cffi cython \
    ray modin
    #tensorflow-gpu

# conda clean -tipsy
