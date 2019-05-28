#!/bin/bash

#SBATCH --partition=day
#SBATCH --job-name=QuNexSingularity_Commands
#SBATCH --ntasks=1 --nodes=1
#SBATCH --mem-per-cpu=15000
#SBATCH --time=23:59:00

# -- QuNex Singularity Container Image absolute paths
QuNexCONTAINER=${TOOLS}/Singularity
PATH=${QuNexCONTAINER}:${PATH}
export QuNexCONTAINER PATH

# -- Command to execute the shell script with QuNex-specific commands
singularity exec ${QuNexCONTAINER}/qunex_suite.simg ${TOOLS}/qunex/library/bin/QuNexSingularity_Commands.sh