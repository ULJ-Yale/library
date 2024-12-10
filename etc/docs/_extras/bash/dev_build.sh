#!/usr/bin/env bash

# Version of pre_build.sh used for development (may not be up to date)

cd $(dirname $0)

echo "---> Copying latest wiki version from local qunex.wiki folder"
cp -r ../../../../../../qunex.wiki ../../wiki

QUNEXMCOMMAND="matlab" # To supress a warning
export QUNEXMCOMMAND

python3 ../python/generate_index.py

python3 ../python/extract_unsupported_docstrings.py

python3 ../python/generate_all_commands_rsts.py

# The actual build step
cd ../..
python3 -m sphinx -W -T -E -b html -d _build/doctrees -D language=en . _build/html
