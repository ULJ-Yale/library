#!/bin/bash

#SBATCH --partition=day
#SBATCH --job-name=QuNexSingularity_Commands
#SBATCH --ntasks=1 --nodes=1
#SBATCH --mem-per-cpu=15000
#SBATCH --time=23:59:00

# -- Qu|Nex Singularity Container Image absolute paths
QUNEXCONTAINER=${TOOLS}/Singularity
PATH=${QUNEXCONTAINER}:${PATH}
export QUNEXCONTAINER PATH

# -- Command to execute the shell script with Qu|Nex-specific commands
singularity exec ${QUNEXCONTAINER}/qunex_suite.simg ${TOOLS}/qunex/library/bin/QuNexSingularity_Commands.sh