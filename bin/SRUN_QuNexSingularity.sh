#!/bin/bash
TimeStamp=`date +%Y-%m-%d-%H-%M-%S`
sbatch --output=${HOME}/slurm-qunex-singularity-testrun-${TimeStamp}.out --export=TimeStamp=${TimeStamp},HOME=${HOME} ${TOOLS}/qunex/library/bin/SBATCH_QuNexSingularity.sh

