#!/usr/bin/env bash

cd $(dirname $0)

echo "---> Cloning latest wiki version from GitHub"
echo "    ... Cloning from https://github.com/ULJ-Yale/qunex.wiki.git"
git clone --depth 1 https://github.com/ULJ-Yale/qunex.wiki.git ../../wiki

# dev
# cp -r ../../../../../../qunex.wiki/ ../../wiki  # useful during development

python3 ../python/generate_index.py

python3 ../python/extract_unsupported_docstrings.py

python3 ../python/generate_gmri_rsts.py

# use the following command to build the documentation locally from $QUNEXPATH/docs:
# python3 -m sphinx -W -T -E -b html -d _build/doctrees -D language=en . _build/html
