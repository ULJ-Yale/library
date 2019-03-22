#!/bin/bash
TimeStamp=`date +%Y-%m-%d-%H-%M-%S`
sbatch --output=${HOME}/slurm-mnap-singularity-testrun-${TimeStamp}.out --export=TimeStamp=${TimeStamp},HOME=${HOME} ${TOOLS}/mnaptools/library/bin/SBATCH_MNAPSingularity.sh

