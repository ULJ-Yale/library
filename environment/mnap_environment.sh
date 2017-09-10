#!/bin/bash
# set -x

#~ND~FORMAT~MARKDOWN~
#~ND~START~
#
# mnap_environment.sh
#
# ## Copyright Notice
#
# * Copyright (C) 2015 Anticevic Lab, Yale University
#
# ## Author(s)
#
# * Alan Anticevic, Department of Psychiatry, Yale University
# * Grega Repovs, Department of Psychology, University of Ljubljana
#
# ## Product
#
# * Global environment script for MNAP Repos
#
# ## License
#
# See the [LICENSE](https://bitbucket.org/mnap/library/src/ecaf2b6f9d60f07b89dd9bdd2a413e91baab22e9/LICENSE.md?at=master&fileviewer=file-view-default)
#
# ## Description:
#
# * This is a general script developed as a front-end environment and path organization for the MNAP infrastructure
# * This script needs to be sourced in each users .bash_profile like so:
#
# TOOLS=/PATH_TO/MNAP/
# export TOOLS
# source $TOOLS/library/environment/mnap_environment.sh
#
# ### Installed Software (Prerequisites) - these are sourced in $TOOLS/library/environment/mnap_environment.sh
#
# * Connectome Workbench (v1.0 or above)
# * FSL (version 5.0.6 or above with CUDA libraries)
# * FreeSurfer (5.3 HCP version or later)
# * MATLAB (version 2012b or above with Signal Processing, Statistics and Machine Learning and Image Processing Toolbox)
# * FIX ICA
# * PALM
# * Python (version 2.7 or above with numpy)
# * AFNI
# * Gradunwarp
# * Human Connectome Pipelines (Modified versions for single-band preprocessing)
# * R Statistical Environment with ggplot
# * dcm2nii (23-June-2017 release)
# * pydicom
# * MNAP niutilities Repo
# * MNAP matlab Repo
#
#~ND~END~

###########################################################################################################################
###################################################  CODE START ###########################################################
###########################################################################################################################

# ------------------------------------------------------------------------------
#  Setup color outputs
# ------------------------------------------------------------------------------

BLACK_F="\033[30m"; BLACK_B="\033[40m"
RED_F="\033[31m"; RED_B="\033[41m"
GREEN_F="\033[32m"; GREEN_B="\033[42m"
YELLOW_F="\033[33m"; YELLOW_B="\033[43m"
BLUE_F="\033[34m"; BLUE_B="\033[44m"
MAGENTA_F="\033[35m"; MAGENTA_B="\033[45m"
CYAN_F="\033[36m"; CYAN_B="\033[46m"
WHITE_F="\033[37m"; WHITE_B="\033[47m"

reho() {
    echo -e "$RED_F $1 \033[0m"
}

geho() {
    echo -e "$GREEN_F $1 \033[0m"
}

yeho() {
    echo -e "$YELLOW_F $1 \033[0m"
}

beho() {
    echo -e "$BLUE_F $1 \033[0m"
}

mageho() {
    echo -e "$MAGENTA_F $1 \033[0m"
}

cyaneho() {
    echo -e "$CYAN_F $1 \033[0m"
}

weho() {
    echo -e "$WHITE_F $1 \033[0m"
}


# ------------------------------------------------------------------------------
#  setup server login messages
# ------------------------------------------------------------------------------


HOST=`hostname`
MyID=`whoami`

# ------------------------------------------------------------------------------
#  License disclaimer
# ------------------------------------------------------------------------------

geho ""
geho ""
geho "------------------------------------------------------------------------------"
geho ""
geho "             _   _ _____   ____  _       _     _                             "
geho "            | \ | |___ /  |  _ \(_)_   _(_)___(_) ___  _ __                  "
geho "            |  \| | |_ \  | | | | \ \ / / / __| |/ _ \| '_ \                 "
geho "            | |\  |___) | | |_| | |\ V /| \__ \ | (_) | | | |                "
geho "            |_| \_|____/  |____/|_| \_/ |_|___/_|\___/|_| |_|                "
geho ""
geho "               at Yale University Department of Psychiatry                   "
geho ""
geho "                     Software Licence Disclaimer:                            "
geho ""
geho " =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=--=-=-= "
geho " Use of this software is subject to the terms and conditions defined by the  "
geho " Yale University Copyright Policies:                                         "
geho "    http://ocr.yale.edu/faculty/policies/yale-university-copyright-policy    "
geho " and the terms and conditions defined in the file 'LICENSE.txt' which is     "
geho " a part of this source code package.                                         "
geho " =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=--=-=-= "
geho ""
geho ""
geho "                  You are logged in as $MyID on `hostname`"
geho ""
geho "                  Setting up MNAP environment and paths ... "
geho "..........................................................................."
geho ""
geho "   		    ███╗   ███╗███╗   ██╗ █████╗ ██████╗                   	" 
geho "   		    ████╗ ████║████╗  ██║██╔══██╗██╔══██╗                  	" 
geho "   		    ██╔████╔██║██╔██╗ ██║███████║██████╔╝                  	"
geho "   		    ██║╚██╔╝██║██║╚██╗██║██╔══██║██╔═══╝                   	"
geho "   		    ██║ ╚═╝ ██║██║ ╚████║██║  ██║██║                       	"  
geho "   		    ╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝                       	"
geho "..........................................................................."
geho ""
geho ""
geho ""

# ------------------------------------------------------------------------------
#  Setup privileges and environment disclaimer
# ------------------------------------------------------------------------------

umask 002
. ~/.bashrc

# ------------------------------------------------------------------------------
#  Setup master software folder
# ------------------------------------------------------------------------------

TOOLS=/software/
export TOOLS
# --- Set up prompt
PS1="\[\e[0;36m\][MNAP \W]\$\[\e[0m\] "
PROMPT_COMMAND='echo -ne "\033]0;MNAP: ${PWD}\007"'

# ------------------------------------------------------------------------------
# Set FSL environment libraries for queuing system
# ------------------------------------------------------------------------------

#export SGE_ROOT=1
#export FSLGECUDAQ=anticevic-gpu

# ------------------------------------------------------------------------------
#  Load dependent software - FSL, FreeSurfer, Workbench, AFNI, PALM
# ------------------------------------------------------------------------------

# -- FSL binaries
FSLDIR=$TOOLS/fsl-5.0.9/fsl
PATH=${FSLDIR}/bin:${PATH}
. ${FSLDIR}/etc/fslconf/fsl.sh > /dev/null 2>&1
export FSLDIR PATH
MATLABPATH=$FSLDIR:$MATLABPATH
export MATLABPATH

# -- FSL fsl_sub command path edited for the Yale HPC environment
FSLSUBDIR=/gpfs/apps/hpc/Apps/FSL/5.0.6/fsl/bin/
alias fsl_sub.yale='fsl_sub.lsf'
PATH=${FSLSUBDIR}:${PATH}
export FSLSUBDIR PATH
MATLABPATH=$FSLSUBDIR:$MATLABPATH
export MATLABPATH

# -- FIX ICA path
FIXICADIR=${TOOLS}/fix1.06
PATH=${FIXICADIR}:${PATH}
export FIXICADIR PATH
MATLABPATH=$FIXICADIR:$MATLABPATH
export MATLABPATH

# -- POST FIX ICA path
POSTFIXICADIR=${TOOLS}/MNAP/hcpmodified/PostFix
PATH=${POSTFIXICADIR}:${PATH}
export POSTFIXICADIR PATH
MATLABPATH=$POSTFIXICADIR:$MATLABPATH
export MATLABPATH

# -- FSL probtrackx2_gpu command path
FSLGPUDIR=${TOOLS}/fsl-5.0.6/fsl/bin
PATH=${FSLGPUDIR}:${PATH}
export FSLGPUDIR PATH
MATLABPATH=$FSLGPUDIR:$MATLABPATH
export MATLABPATH

# -- FreeSurfer binaries
FREESURFER_HOME=$TOOLS/freesurfer-6.0/freesurfer
PATH=${FREESURFER_HOME}:${PATH}
export FREESURFER_HOME PATH
. ${FREESURFER_HOME}/SetUpFreeSurfer.sh > /dev/null 2>&1

# -- Workbench binaries
WORKBENCHDIR=${TOOLS}/workbench/bin_rh_linux64
PATH=${WORKBENCHDIR}:${PATH}
export WORKBENCHDIR PATH
MATLABPATH=$WORKBENCHDIR:$MATLABPATH
export MATLABPATH

# -- PALM binaries
PALMPATH=${TOOLS}/PALM/palm-alpha103
PATH=${PALMPATH}:${PATH}
export PALMPATH PATH
MATLABPATH=$PALMPATH:$MATLABPATH
export MATLABPATH

# -- AFNI binaries
AFNIPATH=${TOOLS}/afni_linux_openmp_64
PATH=${AFNIPATH}:${PATH}
export AFNIPATH PATH
MATLABPATH=$AFNIPATH:$MATLABPATH
export MATLABPATH

# -- dcm2nii path
DCMNII=$TOOLS/dcm2niix/build/bin
PATH=${DCMNII}:${PATH}
export DCMNII PATH

# ------------------------------------------------------------------------------
#  MNAP - General Code
# ------------------------------------------------------------------------------

if [ -e ~/.mnapdev ]
then
    MNAPPATH=$TOOLS/MNAPdev
    echo ""
    reho " --- NOTE: You are in MNAP development mode! ----"
	echo ""
	reho " ---> MNAP path is set to: $MNAPPATH"
	echo ""
else
    MNAPPATH=$TOOLS/MNAP
fi

APPATH=$MNAPPATH/general
PATH=${APPATH}:${PATH}
export APPATH PATH
PATH=$MNAPPATH/general/functions:$PATH
# AP Supporting functions
export APFUNCTIONS=${APPATH}/functions 
# Setup aliases for running the general pipeline
alias AP='bash AnalysisPipeline.sh'
alias AnalysisPipeline='bash AnalysisPipeline.sh'
alias ap='bash AnalysisPipeline.sh'
alias mnap='bash AnalysisPipeline.sh'

MATLABPATH=$MNAPPATH/general:$MATLABPATH
export MATLABPATH

HCPATLAS=$MNAPPATH/library/HCP
PATH=${HCPATLAS}:${PATH}
export HCPATLAS PATH
MATLABPATH=$HCPATLAS:$MATLABPATH
export MATLABPATH

# ------------------------------------------------------------------------------
#  setup HCP Pipeline paths
# ------------------------------------------------------------------------------

export HCPPIPEDIR=$MNAPPATH/hcpmodified
export CARET7DIR=$TOOLS/workbench/bin_rh_linux64
export GRADUNWARPDIR=$TOOLS/pylib/gradunwarp/core
export HCPPIPEDIR_Templates=${HCPPIPEDIR}/global/templates
export HCPPIPEDIR_Bin=${HCPPIPEDIR}/global/binaries
export HCPPIPEDIR_Config=${HCPPIPEDIR}/global/config
export HCPPIPEDIR_PreFS=${HCPPIPEDIR}/PreFreeSurfer/scripts
export HCPPIPEDIR_FS=${HCPPIPEDIR}/FreeSurfer/scripts
export HCPPIPEDIR_PostFS=${HCPPIPEDIR}/PostFreeSurfer/scripts
export HCPPIPEDIR_fMRISurf=${HCPPIPEDIR}/fMRISurface/scripts
export HCPPIPEDIR_fMRIVol=${HCPPIPEDIR}/fMRIVolume/scripts
export HCPPIPEDIR_tfMRI=${HCPPIPEDIR}/tfMRI/scripts
export HCPPIPEDIR_dMRI=${HCPPIPEDIR}/DiffusionPreprocessing/scripts
export HCPPIPEDIR_dMRITract=${HCPPIPEDIR}/DiffusionTractography/scripts
export HCPPIPEDIR_Global=${HCPPIPEDIR}/global/scripts
export HCPPIPEDIR_tfMRIAnalysis=${HCPPIPEDIR}/TaskfMRIAnalysis/scripts
export MSMBin=${HCPPIPEDIR}/MSMBinaries
export HCPPIPEDIR_dMRITracFull=${HCPPIPEDIR}/DiffusionTractographyDense 							
export HCPPIPEDIR_dMRILegacy=/gpfs/project/fas/n3/software/hcpmodified/DiffusionPreprocessingLegacy 
export AutoPtxFolder=${HCPPIPEDIR_dMRITracFull}/autoPtx_HCP_extended 								
export FSLGPUBinary=${HCPPIPEDIR_dMRITracFull}/fsl_gpu_binaries

# ------------------------------------------------------------------------------
#  MNAP - Imaging Utilities, Matlab, Processing
# ------------------------------------------------------------------------------

PATH=$MNAPPATH/processing:$PATH
PATH=$MNAPPATH/niutilities:$PATH
PATH=$MNAPPATH/matlab:$PATH
PATH=$TOOLS/bin:$PATH
PATH=$TOOLS/pylib/gradunwarp-master:$PATH
PATH=$TOOLS/pylib/gradunwarp-master/core:$PATH
PATH=$TOOLS/pylib:$PATH
PATH=$TOOLS/pylib/bin:$PATH

PYTHONPATH=$TOOLS:$PYTHONPATH
PYTHONPATH=$MNAPPATH:$PYTHONPATH
PYTHONPATH=$MNAPPATH/processing:$PYTHONPATH
PYTHONPATH=$MNAPPATH/niutilities:$PYTHONPATH
PYTHONPATH=$MNAPPATH/matlab:$PYTHONPATH
PYTHONPATH=$TOOLS/pylib/gradunwarp-master:$PYTHONPATH
PYTHONPATH=$TOOLS/pylib/gradunwarp-master/core:$PYTHONPATH
PYTHONPATH=$TOOLS/pylib/bin:$PYTHONPATH
PYTHONPATH=$TOOLS/pylib/lib/python2.7/site-packages/:$PYTHONPATH
PYTHONPATH=$TOOLS/pylib:$PYTHONPATH

export PATH
export PYTHONPATH

MATLABPATH=$MNAPPATH/matlab/fcMRI:$MATLABPATH
MATLABPATH=$MNAPPATH/matlab/general:$MATLABPATH
MATLABPATH=$MNAPPATH/matlab/gmri:$MATLABPATH
MATLABPATH=$MNAPPATH/matlab/stats:$MATLABPATH

export MATLABPATH

# ------------------------------------------------------------------------------
#  path to additional libraries
# ------------------------------------------------------------------------------

#LD_LIBRARY_PATH=$TOOLS/lib:$TOOLS/lib/lib:$LD_LIBRARY_PATH
#PKG_CONFIG_PATH=$TOOLS/lib/lib/pkgconfig:$PKG_CONFIG_PATH

#export LD_LIBRARY_PATH
#export PKG_CONFIG_PATH

#PATH=$TOOLS/bin:$TOOLS/lib/bin:$TOOLS/lib/lib/:$PATH
#export PATH

# ------------------------------------------------------------------------------
#  MNAP Commit Functions and Aliases for BitBucket
# ------------------------------------------------------------------------------

# MNAP Library Code
function_commitmnaplibrary() {
	
	cd ${MNAPPATH}/library
	git add ./*
	CommitMessage="${@} --Update-${MyID}-via-`hostname`-`date +%Y-%m-%d-%H-%M-%S`"
	#hg commit . --message="${CommitMessage}"
	#hg push
	git commit . --message="${CommitMessage}"
	git push git@bitbucket.org:mnap/library.git master

}
alias commitmnaplibrary=function_commitmnaplibrary

# MNAP General
function_commitmnapgeneral() {
	
	cd ${MNAPPATH}/general
	git add ./*
	CommitMessage="${@} --Update-${MyID}-via-`hostname`-`date +%Y-%m-%d-%H-%M-%S`"
	git commit . --message="${CommitMessage}"
	git push git@bitbucket.org:mnap/general.git master

}
alias commitmnapgeneral=function_commitmnapgeneral

# MNAP HCPModified
function_commithcpmodified() {
	
	cd ${MNAPPATH}/hcpmodified
	git add ./*
	CommitMessage="${@} --Update-${MyID}-via-`hostname`-`date +%Y-%m-%d-%H-%M-%S`"
	git commit . --message="${CommitMessage}"
	git push git@bitbucket.org:mnap/hcpmodified.git master

}
alias commithcpmodified=function_commithcpmodified

# MNAP Niutilities
function_commitmnapniutilities() {
	
	cd ${MNAPPATH}/niutilities
	git add ./*
	CommitMessage="${@} --Update-${MyID}-via-`hostname`-`date +%Y-%m-%d-%H-%M-%S`"
	#hg commit . --message="${CommitMessage}"
	#hg push
	git commit . --message="${CommitMessage}"
	git push git@bitbucket.org:mnap/niutilities.git master

}
alias commitmnapniutilities=function_commitmnapniutilities

# MNAP Matlab Code
function_commitmnapmatlab() {
	
	cd ${MNAPPATH}/matlab
	git add ./*
	CommitMessage="${@} --Update-${MyID}-via-`hostname`-`date +%Y-%m-%d-%H-%M-%S`"
	#hg commit . --message="${CommitMessage}"
	#hg push
	git commit . --message="${CommitMessage}"
	git push git@bitbucket.org:mnap/matlab.git master

}
alias commitmnapmatlab=function_commitmnapmatlab



