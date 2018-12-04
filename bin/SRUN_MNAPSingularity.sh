#!/bin/bash
CDIR=`pwd`
TimeStamp=`date +%Y-%m-%d-%H-%M-%S`
sbatch --output=${HOME}/slurm-mnap-singularity-testrun-${TimeStamp}.out --export=TimeStamp=${TimeStamp},HOME=${HOME} ${CDIR}/SBATCH_MNAPSingularity.sh

