#!/bin/sh
#
#~ND~FORMAT~MARKDOWN~
#~ND~START~
#
# ## COPYRIGHT NOTICE
#
# Copyright (C) 2015 Anticevic Lab, Yale University
# Copyright (C) 2015 MBLAB, University of Ljubljana
#
# ## AUTHORS(s)
#
# * Alan Anticevic, Department of Psychiatry, Yale University
#
# ## PRODUCT
#
#  mnap_environment.sh
#
# ## LICENSE
#
# * The mnap_environment.sh = the "Software"
# * This Software conforms to the license outlined in the MNAP Suite:
# * https://bitbucket.org/hidradev/mnaptools/src/master/LICENSE.md
#
# ## TODO
#
#
# ## DESCRIPTION:
#
# * This is a general script developed as a front-end environment and path organization for the MNAP infrastructure
#
# ## PREREQUISITE INSTALLED SOFTWARE
#
# * MNAP Suite
#
# ## PREREQUISITE ENVIRONMENT VARIABLES
#
# * This script needs to be sourced in each users .bash_profile like so:
#
#    TOOLS=/<absolute_path_to_software_folder>
#    export TOOLS
#    source $TOOLS/library/environment/mnap_environment.sh
#
# ## PREREQUISITE PRIOR PROCESSING
# 
# N/A
#
#~ND~END~

# ------------------------------------------------------------------------------
# -- General help usage function
# ------------------------------------------------------------------------------

usage() {
    echo ""
    echo "-- DESCRIPTION:"
    echo ""
    echo "This function implements the global environment setup for the MNAP Suite."
    echo ""
    echo ""
    echo "    Configure the environment script by adding the following lines to the .bash_profile "
    echo ""
    echo "    -->TOOLS=<path_to_folder_with_mnap_software> "
    echo "    -->export TOOLS "
    echo "    -->source <path_to_folder_with_mnap_software>/library/environment/mnap_environment.sh "
    echo ""
    echo "    Permissions of this file need to be set to 770 "
    echo ""
    echo "-- REQUIRED DEPENDENCIES:"
    echo ""
    echo " The MNAP Suite assumes a set default folder names for dependencies if undefined by user environment."
    echo " These are defined relative to the ${TOOLS} folder which should be set as a global system variable."
    echo ""
    echo "        FSL                 --> FSLFolder=fsl-5.0.9/fsl"
    echo "        FIX ICA             --> FIXICAFolder=fix1.06 "
    echo "        FreeSurfer          --> FREESURFERDIR=freesurfer-6.0/freesurfer "
    echo "        FreeSurferScheduler --> FreeSurferSchedulerDIR=FreeSurferScheduler "
    echo "        workbench           --> HCPWBDIR=workbench "
    echo "        PALM                --> PALMDIR=PALM/PALM "
    echo "        AFNI                --> AFNIDIR=afni_linux_openmp_64 "
    echo "        dcm2niix            --> DCM2NIIDIR=dcm2niix "
    echo ""
    echo " These defaults can be redefined if the above relative paths are declared as global variables in the .bash_profile profile."
    echo ""
}

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= CODE START =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=

# ------------------------------------------------------------------------------
# -- Setup color outputs
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
    echo -e "$RED_F$1 \033[0m"
}

geho() {
    echo -e "$GREEN_F$1 \033[0m"
}

yeho() {
    echo -e "$YELLOW_F$1 \033[0m"
}

beho() {
    echo -e "$BLUE_F$1 \033[0m"
}

mageho() {
    echo -e "$MAGENTA_F$1 \033[0m"
}

cyaneho() {
    echo -e "$CYAN_F$1 \033[0m"
}

weho() {
    echo -e "$WHITE_F$1 \033[0m"
}

# -- Set general options functions
opts_GetOpt() {
sopt="$1"
shift 1
for fn in "$@" ; do
	if [ `echo ${fn} | grep -- "^${sopt}=" | wc -w` -gt 0 ]; then
		echo "${fn}" | sed "s/^${sopt}=//"
		return 0
	fi
done
}

if [ "$1" == "--help" ]; then
	usage
	exit 0
fi

# ------------------------------------------------------------------------------
# -- Setup server login messages
# ------------------------------------------------------------------------------


HOST=`hostname`
MyID=`whoami`

# ------------------------------------------------------------------------------
# -- Setup privileges and environment disclaimer
# ------------------------------------------------------------------------------

umask 002

# ------------------------------------------------------------------------------
# -- Check Operating System (needed for some apps like Workbench)
# ------------------------------------------------------------------------------

if [ "$(uname)" == "Darwin" ]; then
	OperatingSystem="Darwin"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	OperatingSystem="Linux"
fi

# ------------------------------------------------------------------------------
# -- Check for and setup master software folder
# ------------------------------------------------------------------------------

if [ -z ${TOOLS} ]; then
	echo ""
	reho " -- ERROR: TOOLS environment variable not setup on this system."
	reho "    Please add to your environment profile (e.g. .bash_profile):"
	echo ""
	echo "    TOOLS=/<absolute_path_to_software_folder>/"
	reho 1
	echo ""
else
	export TOOLS
fi

# ------------------------------------------------------------------------------
# -- Set up prompt
# ------------------------------------------------------------------------------

PS1="\[\e[0;36m\][MNAP \W]\$\[\e[0m\] "
PROMPT_COMMAND='echo -ne "\033]0;MNAP: ${PWD}\007"'

# ------------------------------------------------------------------------------
# Set FSL environment libraries for queuing system
# ------------------------------------------------------------------------------

# export SGE_ROOT=1
# export FSLGECUDAQ=<name_of_queue>

# ------------------------------------------------------------------------------
# -- MNAP - General Code
# ------------------------------------------------------------------------------

# ---- changed to work with new clone/branches setup

if [ -e ~/mnapinit.sh ]
then
    source ~/mnapinit.sh
else
    MNAPREPO="mnaptools"
fi

PATH=${MNAPREPO}:${PATH}
export MNAPREPO PATH
MNAPPATH=${TOOLS}/${MNAPREPO}

if [ -e ~/mnapinit.sh ]
then
    echo ""
    reho " --- NOTE: MNAP is set by your ~/mnapinit.sh file! ----"
    echo ""
    reho " ---> MNAP path is set to: ${MNAPPATH} "
    echo ""
fi

# ------------------------------------------------------------------------------
# -- Load dependent software - FSL, FreeSurfer, Workbench, AFNI, PALM
# ------------------------------------------------------------------------------

# -- Set default folder names for dependencies if undefined by user environment: 
#
# FSL
# FIX ICA
# FreeSurfer
# FreeSurferScheduler
# workbench
# PALM
# AFNI
# dcm2niix
#
# -------------------------------------------------------------------------------

if [[ -z ${FSLFolder} ]]; then FSLFolder="fsl-5.0.9/fsl"; fi
if [[ -z ${FIXICAFolder} ]]; then FIXICAFolder="fix1.06"; fi
if [[ -z ${FREESURFERDIR} ]]; then FREESURFERDIR="freesurfer-6.0/freesurfer"; fi
if [[ -z ${FreeSurferSchedulerDIR} ]]; then FreeSurferSchedulerDIR="FreeSurferScheduler"; fi
if [[ -z ${HCPWBDIR} ]]; then HCPWBDIR="workbench"; fi
if [[ -z ${PALMDIR} ]]; then PALMDIR="PALM/PALM"; fi
if [[ -z ${AFNIDIR} ]]; then AFNIDIR="afni_linux_openmp_64"; fi
if [[ -z ${DCM2NIIDIR} ]]; then DCM2NIIDIR="dcm2niix"; fi

# -- FSL binaries
FSLDIR=${TOOLS}/${FSLFolder}
PATH=${FSLDIR}/bin:${PATH}
. ${FSLDIR}/etc/fslconf/fsl.sh > /dev/null 2>&1
export FSLDIR PATH
MATLABPATH=$FSLDIR:$MATLABPATH
export MATLABPATH

# -- FIX ICA path
FIXICADIR=${TOOLS}/${FIXICAFolder}
PATH=${FIXICADIR}:${PATH}
export FIXICADIR PATH
MATLABPATH=$FIXICADIR:$MATLABPATH
export MATLABPATH

# -- POST FIX ICA path
POSTFIXICADIR=${TOOLS}/${MNAPREPO}/hcpmodified/PostFix
PATH=${POSTFIXICADIR}:${PATH}
export POSTFIXICADIR PATH
MATLABPATH=$POSTFIXICADIR:$MATLABPATH
export MATLABPATH

# -- FSL probtrackx2_gpu command path
FSLGPUDIR=${FSLDIR}/bin
PATH=${FSLGPUDIR}:${PATH}
export FSLGPUDIR PATH
MATLABPATH=$FSLGPUDIR:$MATLABPATH
export MATLABPATH

# -- FreeSurfer binaries
FREESURFER_HOME=${TOOLS}/${FREESURFERDIR}
PATH=${FREESURFER_HOME}:${PATH}
export FREESURFER_HOME PATH
. ${FREESURFER_HOME}/SetUpFreeSurfer.sh > /dev/null 2>&1

# -- FreeSurfer Scheduler for GPU acceleration
FREESURFER_SCHEDULER=${TOOLS}/${FreeSurferSchedulerDIR}
PATH=${FREESURFER_SCHEDULER}:${PATH}
export FREESURFER_SCHEDULER PATH

# -- Workbench binaries (set OS)
if [ "$OperatingSystem" == "Darwin" ]; then
	WORKBENCHDIR=${TOOLS}/${HCPWBDIR}/bin_macosx64
elif [ "$OperatingSystem" == "Linux" ]; then
	WORKBENCHDIR=${TOOLS}/workbench/bin_rh_linux64
fi
PATH=${WORKBENCHDIR}:${PATH}
export WORKBENCHDIR PATH
MATLABPATH=$WORKBENCHDIR:$MATLABPATH
export MATLABPATH

# -- PALM binaries
PALMPATH=${TOOLS}/${PALMDIR}
PATH=${PALMPATH}:${PATH}
export PALMPATH PATH
MATLABPATH=$PALMPATH:$MATLABPATH
export MATLABPATH

# -- AFNI binaries
AFNIPATH=${TOOLS}/${AFNIDIR}
PATH=${AFNIPATH}:${PATH}
export AFNIPATH PATH
MATLABPATH=$AFNIPATH:$MATLABPATH
export MATLABPATH

# -- dcm2niix path
DCMNII=${TOOLS}/${DCM2NIIDIR}/build/bin
PATH=${DCMNII}:${PATH}
export DCMNII PATH

# ------------------------------------------------------------------------------
# -- Setup overal MNAP paths
# ------------------------------------------------------------------------------

MNAPCONNPATH=$MNAPPATH/connector
PATH=${MNAPCONNPATH}:${PATH}
export MNAPCONNPATH PATH
PATH=$MNAPPATH/connector/functions:$PATH
export MNAPFUNCTIONS=${MNAPCONNPATH}/functions
MATLABPATH=$MNAPPATH/connector:$MATLABPATH
export MATLABPATH

HCPATLAS=$MNAPPATH/library/data/atlases/HCP
PATH=${HCPATLAS}:${PATH}
export HCPATLAS PATH
MATLABPATH=$HCPATLAS:$MATLABPATH
export MATLABPATH

TemplateFolder=$MNAPPATH/library/data/
PATH=${TemplateFolder}:${PATH}
export TemplateFolder PATH
MATLABPATH=$TemplateFolder:$MATLABPATH
export MATLABPATH

alias mnap='bash $MNAPPATH/connector/mnap.sh'
alias mnap_environment='$MNAPPATH/library/environment/mnap_environment.sh --help'

# -- Checks for version
showVersion() {
	MNAPVer=`cat ${TOOLS}/${MNAPREPO}/VERSION.md`
	echo ""
	geho " Loading Multimodal Neuroimaging Analysis Platform (MNAP) Suite Version: v${MNAPVer}"
}

# ------------------------------------------------------------------------------
# -- Running matlab vs. octave
# ------------------------------------------------------------------------------

if [ -e ~/.mnapuseoctave ]
then
    MNAPMCOMMAND='octave -q --eval'
    module load Libs/netlib
    module load Apps/Octave/4.2.1
    echo ""
    reho " --- NOTE: You are set to use Octave instead of Matlab! ----"
    echo ""
    if [ ! -e ~/.octaverc ]
    then
        cp ${MNAPPATH}/library/.octaverc ~/.octaverc
    fi
else
    # -- Use the following command to run .m code in Matlab
    MNAPMCOMMAND='matlab -nojvm -nodisplay -nosplash -r'
fi

export MNAPMCOMMAND


# ------------------------------------------------------------------------------
# -- Setup HCP Pipeline paths
# ------------------------------------------------------------------------------

export HCPPIPEDIR=${MNAPPATH}/hcpmodified
if [ -e ~/.mnaphcpe ];
	then
	export HCPPIPEDIR=${MNAPPATH}/hcpextendedpull
	echo ""
	reho " --- NOTE: You are in MNAP HCP development mode! ----"
	echo ""
	reho " ---> MNAP path is set to: $HCPPIPEDIR"
	echo ""
fi
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
# -- MNAP - Imaging Utilities, Matlab, Processing
# ------------------------------------------------------------------------------

# -- Make sure gmri is executable
if [[ -z `ls -ltr $MNAPPATH/niutilities/gmri | grep "rwxrwx"` ]]; then
	chmod 770 $MNAPPATH/niutilities/gmri
fi

PATH=$MNAPPATH/connector:$PATH
PATH=$MNAPPATH/niutilities:$PATH
PATH=$MNAPPATH/matlab:$PATH
PATH=$TOOLS/bin:$PATH
PATH=$TOOLS/pylib/gradunwarp-master:$PATH
PATH=$TOOLS/pylib/gradunwarp-master/core:$PATH
PATH=$TOOLS/pylib/xmlutils.py:$PATH
PATH=$TOOLS/pylib:$PATH
PATH=$TOOLS/pylib/bin:$PATH
PATH=$TOOLS/MeshNet:$PATH

PYTHONPATH=$TOOLS:$PYTHONPATH
PYTHONPATH=$MNAPPATH:$PYTHONPATH
PYTHONPATH=$MNAPPATH/connector:$PYTHONPATH
PYTHONPATH=$MNAPPATH/niutilities:$PYTHONPATH
PYTHONPATH=$MNAPPATH/matlab:$PYTHONPATH
PYTHONPATH=$TOOLS/pylib/gradunwarp-master:$PYTHONPATH
PYTHONPATH=$TOOLS/pylib/gradunwarp-master/core:$PYTHONPATH
PYTHONPATH=$TOOLS/pylib/xmlutils.py:$PYTHONPATH
PYTHONPATH=$TOOLS/pylib/bin:$PYTHONPATH
PYTHONPATH=$TOOLS/pylib/lib/python2.7/site-packages/:$PYTHONPATH
PYTHONPATH=$TOOLS/pylib:$PYTHONPATH
PYTHONPATH=$TOOLS/MeshNet:$PYTHONPATH

export PATH
export PYTHONPATH

MATLABPATH=$MNAPPATH/matlab/fcMRI:$MATLABPATH
MATLABPATH=$MNAPPATH/matlab/general:$MATLABPATH
MATLABPATH=$MNAPPATH/matlab/gmri:$MATLABPATH
MATLABPATH=$MNAPPATH/matlab/stats:$MATLABPATH

export MATLABPATH

# ------------------------------------------------------------------------------
# -- Path to additional libraries
# ------------------------------------------------------------------------------

# -- Define additional paths here

# ------------------------------------------------------------------------------
#  MNAP Functions and Aliases for BitBucket
# ------------------------------------------------------------------------------

# -- Update MNAP code by checking if using submodules or individual repos:

# -- Update all submodules
function_mnapupdateall() {
	unset MNAPBranch
	MNAPBranch=`opts_GetOpt "--branch" $@`
	if [[ -z $MNAPBranch ]]; then reho ""; reho "--branch flag not defined."; echo ""; return 1; fi
	echo ""
	geho "-- Pulling repositories as submodules in $MNAPPATH from $MNAPBranch..."
	echo ""
	cd $MNAPPATH; git pull origin ${MNAPBranch}; git submodule foreach git pull origin ${MNAPBranch}
}
alias mnapupdateall=function_mnapupdateall


# -- Commit function for MNAP Suite main repo
function_commitmnapmain() {
	unset MNAPBranch
	CommitMessage=`opts_GetOpt "--message" $@`
	MNAPBranch=`opts_GetOpt "--branch" $@`
	if [[ -z $MNAPBranch ]]; then reho ""; reho "--branch flag not defined."; echo ""; return 1; fi
	CommitMessage="$CommitMessage --Update-${MyID}-via-`hostname`-`date +%Y-%m-%d-%H-%M-%S`"
	echo ""
	geho "-- Committing changes in MNAP Suite main repo ${MNAPPATH} to branch ${MNAPBranch}"
	cd ${MNAPPATH}
	git add ./*
	git commit . --message="${CommitMessage}"
	git push origin ${MNAPBranch}
	echo ""
	geho "--- Committing done."
	echo ""
}
alias commitmnapmain=function_commitmnapmain

# -- Commit function for all of MNAP Suite Code across modules
function_commitmnapall() {
	unset MNAPBranch
	CommitMessage=`opts_GetOpt "--message" $@`
	MNAPBranch=`opts_GetOpt "--branch" $@`
	if [[ -z $MNAPBranch ]]; then reho ""; reho "--branch flag not defined."; echo ""; return 1; fi
	CommitMessage="$CommitMessage --Update-${MyID}-via-`hostname`-`date +%Y-%m-%d-%H-%M-%S`"
	geho "-- Committing changes in submodule ${MNAPPATH}/library..."
	cd ${MNAPPATH}/library
	git add ./*
	git commit . --message="${CommitMessage}"
	git push origin ${MNAPBranch}
	echo "---"
	echo ""
	geho "-- Committing changes in submodule ${MNAPPATH}/connector..."
	cd ${MNAPPATH}/connector
	git add ./*
	git commit . --message="${CommitMessage}"
	git push origin ${MNAPBranch}
	echo "---"
	echo ""
	geho "-- Committing changes in submodule ${MNAPPATH}/hcpmodified..."
	cd ${MNAPPATH}/hcpmodified
	git add ./*
	git commit . --message="${CommitMessage}"
	git push origin ${MNAPBranch}
	echo "---"
	echo ""
	geho "-- Committing changes in submodule ${MNAPPATH}/niutilities..."
	cd ${MNAPPATH}/niutilities
	git add ./*
	git commit . --message="${CommitMessage}"
	git push origin ${MNAPBranch}
	echo "---"
	echo ""
	geho "-- Committing changes in submodule ${MNAPPATH}/matlab..."
	cd ${MNAPPATH}/matlab
	git add ./*
	git commit . --message="${CommitMessage}"
	git push origin ${MNAPBranch}
	echo "---"
	echo ""
	geho "-- Committing changes in main module ${MNAPPATH}..."
	cd ${MNAPPATH}
	git add ./*
	git commit . --message="${CommitMessage}"
	git push origin ${MNAPBranch}
}
alias commitmnapall=function_commitmnapall

# -- Update individual repos
function_mnapupdate_individual() {
	unset MNAPBranch
	MNAPBranch=`opts_GetOpt "--branch" $@`
	if [[ -z $MNAPBranch ]]; then reho ""; reho "--branch flag not defined."; echo ""; return 1; fi
	echo ""
	beho "-- Pulling individual repositories in $MNAPPATH..."
	echo ""
	cd ${MNAPPATH}/library; git pull origin ${MNAPBranch}
	cd ${MNAPPATH}/connector; git pull origin ${MNAPBranch}
	cd ${MNAPPATH}/matlab; git pull origin ${MNAPBranch}
	cd ${MNAPPATH}/hcpmodified; git pull origin ${MNAPBranch}
	cd ${MNAPPATH}/niutilities; git pull origin ${MNAPBranch}
	}
alias mnapupdateindiv=function_mnapupdate_individual

# -- Commit MNAP Library Code
function_commitmnaplibrary() {
	unset MNAPBranch
	CommitMessage=`opts_GetOpt "--message" $@`
	MNAPBranch=`opts_GetOpt "--branch" $@`
	if [[ -z $MNAPBranch ]]; then reho ""; reho "--branch flag not defined."; echo ""; return 1; fi
	CommitMessage="$CommitMessage --Update-${MyID}-via-`hostname`-`date +%Y-%m-%d-%H-%M-%S`"
	cd ${MNAPPATH}/library
	git add ./*
	git commit . --message="${CommitMessage}"
	git push git@bitbucket.org:hidradev/library.git ${MNAPBranch}
}
alias commitmnaplibrary=function_commitmnaplibrary

# -- Commit MNAP Connector Code
function_commitmnapconnector() {
	unset MNAPBranch
	CommitMessage=`opts_GetOpt "--message" $@`
	MNAPBranch=`opts_GetOpt "--branch" $@`
	if [[ -z $MNAPBranch ]]; then reho ""; reho "--branch flag not defined."; echo ""; return 1; fi
	CommitMessage="$CommitMessage --Update-${MyID}-via-`hostname`-`date +%Y-%m-%d-%H-%M-%S`"
	cd ${MNAPPATH}/connector
	git add ./*
	git commit . --message="${CommitMessage}"
	git push git@bitbucket.org:hidradev/connector.git ${MNAPBranch}
}
alias commitmnapconnector=function_commitmnapconnector

# -- Commit MNAP HCPModified
function_commithcpmodified() {
	unset MNAPBranch
	CommitMessage=`opts_GetOpt "--message" $@`
	MNAPBranch=`opts_GetOpt "--branch" $@`
	if [[ -z $MNAPBranch ]]; then reho ""; reho "--branch flag not defined."; return 1; fi
	CommitMessage="$CommitMessage --Update-${MyID}-via-`hostname`-`date +%Y-%m-%d-%H-%M-%S`"
	cd ${MNAPPATH}/hcpmodified
	git add ./*
	git commit . --message="${CommitMessage}"
	git push git@bitbucket.org:hidradev/hcpmodified.git ${MNAPBranch}
}
alias commithcpmodified=function_commithcpmodified

# -- Commit MNAP HCPExtended --> HCPe-MNAP branch
function_commithcpextended() {
	unset MNAPBranch
	CommitMessage=`opts_GetOpt "--message" $@`
	MNAPBranch=`opts_GetOpt "--branch" $@`
	if [[ -z $MNAPBranch ]]; then reho ""; reho "--branch flag not defined."; echo ""; return 1; fi
	CommitMessage="$CommitMessage --Update-${MyID}-via-`hostname`-`date +%Y-%m-%d-%H-%M-%S`"
	cd ${MNAPPATH}/hcpextendedpull
	git add ./*
	git commit . --message="${CommitMessage}"
	git push git@bitbucket.org:hidradev/hcpextendedpull.git ${MNAPBranch}
}

# -- Commit MNAP Niutilities
function_commitmnapniutilities() {
	unset MNAPBranch
	CommitMessage=`opts_GetOpt "--message" $@`
	MNAPBranch=`opts_GetOpt "--branch" $@`
	if [[ -z $MNAPBranch ]]; then reho ""; reho "--branch flag not defined."; echo ""; return 1; fi
	CommitMessage="$CommitMessage --Update-${MyID}-via-`hostname`-`date +%Y-%m-%d-%H-%M-%S`"
	cd ${MNAPPATH}/niutilities
	git add ./*
	git commit . --message="${CommitMessage}"
	git push git@bitbucket.org:hidradev/niutilities.git ${MNAPBranch}
}
alias commitmnapniutilities=function_commitmnapniutilities

# -- Commit MNAP Matlab Code
function_commitmnapmatlab() {
	unset MNAPBranch
	CommitMessage=`opts_GetOpt "--message" $@`
	MNAPBranch=`opts_GetOpt "--branch" $@`
	if [[ -z $MNAPBranch ]]; then reho ""; reho "--branch flag not defined."; echo ""; return 1; fi
	CommitMessage="$CommitMessage --Update-${MyID}-via-`hostname`-`date +%Y-%m-%d-%H-%M-%S`"
	cd ${MNAPPATH}/matlab
	git add ./*
	git commit . --message="${CommitMessage}"
	git push git@bitbucket.org:hidradev/matlab.git ${MNAPBranch}
}
alias commitmnapmatlab=function_commitmnapmatlab

# ------------------------------------------------------------------------------
# -- License and version disclaimer
# ------------------------------------------------------------------------------

showVersion
geho ""
geho "  You are logged in as user: $MyID on machine: `hostname`                    "
geho ""
geho "                  ███╗   ███╗███╗   ██╗ █████╗ ██████╗                       " 
geho "                  ████╗ ████║████╗  ██║██╔══██╗██╔══██╗                      " 
geho "                  ██╔████╔██║██╔██╗ ██║███████║██████╔╝                      "
geho "                  ██║╚██╔╝██║██║╚██╗██║██╔══██║██╔═══╝                       "
geho "                  ██║ ╚═╝ ██║██║ ╚████║██║  ██║██║                           "  
geho "                  ╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝                           "
geho ""
geho "                      COPYRIGHT & LICENSE NOTICE:                            "
geho ""
geho " Use of this software is subject to the terms and conditions defined by the  "
geho " Yale University Copyright Policies:                                         "
geho "    http://ocr.yale.edu/faculty/policies/yale-university-copyright-policy    "
geho " and the terms and conditions defined in the file 'LICENSE.md' which is      "
geho " a part of the MNAP Suite source code package:"
geho "    https://bitbucket.org/hidradev/mnaptools/src/master/LICENSE.md"
geho ""
