#!/bin/bash -i

# -- Source the environment
source /opt/qunex/library/environment/qunex_environment.sh

# -- Add CUDA libs (docker only)
source /opt/qunex/library/environment/qunex_cuda_setup.sh

# -- Execute the call
/opt/qunex/connector/qunex.sh ${@:1}
