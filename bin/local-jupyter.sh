#!/bin/bash
# Start jupyter on localhost

set -Eeuo pipefail

set +u
eval "$(conda shell.bash hook)"
conda activate notebook_env
set -u

JUPYTER_PORT=8888
JUPYTER_IP=localhost

exec jupyter lab \
    --port "$JUPYTER_PORT" \
    --ip "$JUPYTER_IP" \
    --NotebookApp.token="" \
    --NotebookApp.password="" \
    --NotebookApp.disable_check_xsrf=True \
    --no-browser
