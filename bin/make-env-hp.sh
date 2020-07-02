#!/bin/bash
# Make the hodgepodge environment

eval "$(conda shell.bash hook)"

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

conda activate "$CONDA_ENV"

conda install -y \
    pytorch torchtext torchvision cudatoolkit=10.1 -c pytorch

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
    tensorflow-gpu keras \
    tensorboardx \
    future \
    pillow \
    graphviz pydot \
    cffi cython

# conda clean -tipsy
