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

conda create -y -n "$CONDA_ENV" \
    python=3.7 ipykernel \
    numpy scipy matplotlib pandas \
    networkx \
    statsmodels scikit-learn scikit-image \
    nltk spacy \
    pyarrow dask

conda activate "$CONDA_ENV"

conda install -y \
    pytorch torchvision cudatoolkit=9.0 -c pytorch

pip install \
    black pylint pyflakes pydocstyle \
    click logbook \
    tqdm \
    pyyaml toml \
    bokeh seaborn altair \
    xlrd \
    glom \
    more-itertools \
    tensorflow-gpu \
    tensorboardx

# conda clean -tipsy
