#!/bin/bash
# Start jupyter on localhost

if [[ -z "$CONDA_ROOT" ]] ; then
    echo "\$CONDA_ROOT not defined"
    exit 1
fi
if [[ -z "$JUPYTER_PORT" ]] ; then
    JUPYTER_PORT=8888
fi
if [[ -z "$JUPYTER_IP" ]] ; then
    JUPYTER_IP=localhost
fi
if [[ -z "$NOTEBOOK_DIR" ]] ; then
    NOTEBOOK_DIR="$HOME"
fi

export CONDA_ENV=notebook_env

exec conda-exec \
    jupyter lab \
        --port "$JUPYTER_PORT" \
        --ip "$JUPYTER_IP" \
        --NotebookApp.token="" \
        --NotebookApp.password="" \
        --NotebookApp.disable_check_xsrf=True \
        --notebook-dir "$NOTEBOOK_DIR" \
        --no-browser
