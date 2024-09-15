#!/usr/bin/env bash
set -e

# set git safe.directory
sh -c "git config --global --add safe.directory $PWD"

exec "$@"
