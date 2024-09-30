#!/bin/bash
# Start jupyter on localhost

set -Eeuo pipefail

set +u
eval "$(conda shell.bash hook)"
conda activate hp12
set -u

JUPYTER_PORT=8888
JUPYTER_IP=localhost

exec jupyter lab \
    --port "$JUPYTER_PORT" \
    --ip "$JUPYTER_IP" \
    --ServerApp.token="" \
    --ServerApp.password="" \
    --ServerApp.disable_check_xsrf=True \
    --ServerApp.iopub_data_rate_limit=1e10 \
    --no-browser
