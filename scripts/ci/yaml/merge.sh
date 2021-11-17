#!/bin/bash

set -euo pipefail

DIRECTORY="$1"

yamls="$(ls -1 "${DIRECTORY}")"

for yaml in ${yamls}; do
    cat "${DIRECTORY}/${yaml}"
    echo "---"
done

exit 0
