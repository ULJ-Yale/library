#!/bin/bash -i

# -- Source the environment
source /opt/qunex/library/environment/qunex_environment.sh

# -- Execute the call
/opt/qunex/connector/qunex.sh ${@:1}
