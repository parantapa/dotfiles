#!/bin/bash
# Make hodgepodge environment

if [[ ! -d "$CONDA_ROOT" ]] ; then
    echo "|$CONDA_ROOT not defined"
    exit 1
fi

set -e
set -v

. "$CONDA_ROOT/etc/profile.d/conda.sh"

CONDA_ENV=hp

conda remove -n "$CONDA_ENV" --all

conda create -y -n "$CONDA_ENV"

conda activate "$CONDA_ENV"

conda install -y \
    python=3.7 \
    numpy scipy matplotlib pandas \
    statsmodels scikit-learn \
    pyarrow \
    nltk \
    networkx \
    dask

conda install -y \
    pytorch torchvision cudatoolkit=9.0 -c pytorch

pip install \
    tqdm \
    pyyaml toml \
    bokeh seaborn altair \
    xlrd \
    glom \
    more-itertools \
    tensorFlow-gpu \
    tensorboardx

# conda clean -tipsy
