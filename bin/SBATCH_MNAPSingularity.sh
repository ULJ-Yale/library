#!/bin/bash

#SBATCH --partition=day
#SBATCH --job-name=MNAPSingularity_Commands
#SBATCH --ntasks=1 --nodes=1
#SBATCH --mem-per-cpu=15000
#SBATCH --time=23:59:00

# -- MNAP Singularity Container Image absolute paths
MNAPCONTAINER=${TOOLS}/Singularity
PATH=${MNAPCONTAINER}:${PATH}
export MNAPCONTAINER PATH

# -- Command to execute the shell script with MNAP-specific commands
singularity exec ${MNAPCONTAINER}/mnap_suite.simg ${TOOLS}/mnaptools/library/bin/MNAPSingularity_Commands.sh