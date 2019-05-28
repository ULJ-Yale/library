#!/bin/bash
export MATLABBIN="/gpfs/apps/hpc.rhel6/Apps/Matlab/R2016b/bin"
export PATH=${MATLABBIN}:${PATH}
TimeStamp=`date +%Y-%m-%d-%H-%M-%S`
Output="qunex_singularity_test_${TimeStamp}.out"
export Output
source /opt/qunextools/library/environment/qunex_environment.sh
bash ${QuNexPATH}/connector/qunex.sh >> ~/${Output}
bash ${QuNexPATH}/connector/qunex.sh BOLDParcellation >> ~/${Output}
