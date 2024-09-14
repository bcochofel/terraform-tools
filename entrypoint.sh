#!/usr/bin/env bash
set -e

if [ "$1" = 'pre-commit' ]; then
    # set git safe.directory if we will be running pre-commit command
    git config --global --add safe.directory $PWD
fi

exec "$@"
