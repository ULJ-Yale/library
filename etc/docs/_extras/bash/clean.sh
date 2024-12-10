#!/usr/bin/env bash

cd $(dirname $0)

echo "---> Cleaning docs and related directories"
rm -rf ../../wiki ../../HomeMenu.rst ../../index.rst ../../_build
rm -f ../../api/all_commands/*
find ../../../../../python -name "bash.py" -type f -delete
find ../../../../../python -name "r.py" -type f -delete
