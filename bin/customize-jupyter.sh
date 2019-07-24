#!/bin/bash

if [[ ! -d "$CONDA_ROOT" ]] ; then
    echo "|$CONDA_ROOT not defined"
    exit 1
fi

if [[ -z "$1" ]] ; then
    echo "Need an installation name"
    exit 1
fi
installation_name="$1"

set -v
set -e

. "$CONDA_ROOT/etc/profile.d/conda.sh"

CONDA_ENV=hp

conda activate "$CONDA_ENV"

pip install jupyterthemes

jt -t monokai -f inconsolata -fs 11 -nf latosans -nfs 11 -cellw 99% -lineh 160 -T

# Find out where the custom directory is located
cd "$CONDA_PREFIX/lib/python"*"/site-packages/notebook/static/custom"
CUSTOM_DIR=$(pwd)
cd -

# Locate the custom.js file
CUSTOM_JS="$CUSTOM_DIR/custom.js"

read -d '' title_hostname_js <<EOF
window.document.title = \"$installation_name\" + \": \" + window.document.title;
document.__defineSetter__(\"title\", function(val) {
    document.querySelector(\"title\").childNodes[0].nodeValue = \"$installation_name\" + \": \" + val;
});
EOF

if [[ ! -e "${CUSTOM_JS}-orig" ]] ; then
    cp -a "$CUSTOM_JS" "${CUSTOM_JS}-orig"
fi
cp -a "$CUSTOM_JS-orig" "$CUSTOM_JS"
echo "$title_hostname_js" >> "$CUSTOM_JS"
