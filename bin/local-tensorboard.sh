#!/bin/bash
# Start tensorboard on localhost

set -Eeuo pipefail

set +u
eval "$(conda shell.bash hook)"
conda activate tensorboard_env
set -u

TB_LOGS="$HOME/scratch/tb_logs"

mkdir -p "$TB_LOGS"

exec tensorboard \
    --logdir "$TB_LOGS" \
    --reload_multifile true \
    --reload_multifile_inactive_secs 3600
