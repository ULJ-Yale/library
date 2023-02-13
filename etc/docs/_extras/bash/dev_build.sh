#!/usr/bin/env bash

# Version of pre_build.sh used for development (may not be up to date)

cd $(dirname $0)

echo "==> Copying latest wiki version from local qunex.wiki folder"
cp -r ../../../../../../qunex.wiki ../../wiki

echo "==> Removing [TOC] from wiki files"
find ../../wiki -iname '*.md' -exec sed -i.bkp '/\[TOC\]/d' '{}' ';'
find ../../wiki -name "*.bkp" -type f -delete

python3 ../python/generate_index.py

python3 ../python/extract_unsupported_docstrings.py

python3 ../python/generate_gmri_rsts.py

cd ../..
python3 -m sphinx -W -T -E -b html -d _build/doctrees -D language=en . _build/html
