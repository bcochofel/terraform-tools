#!/usr/bin/env bash

set -e
set -o pipefail

echo ">>> Executing command <<<"
echo ""
echo ""

bash -c "set -e;  set -o pipefail; $1"
