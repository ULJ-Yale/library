#!/bin/bash
export MATLABBIN="/gpfs/apps/hpc.rhel6/Apps/Matlab/R2016b/bin"
export PATH=${MATLABBIN}:${PATH}
TimeStamp=`date +%Y-%m-%d-%H-%M-%S`
Output="mnap_singularity_test_${TimeStamp}.out"
export Output
source /opt/mnaptools/library/environment/mnap_environment.sh
bash ${MNAPPATH}/connector/mnap.sh >> ~/${Output}
bash ${MNAPPATH}/connector/mnap.sh BOLDParcellation >> ~/${Output}
