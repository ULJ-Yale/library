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
    echo "This script implements the global environment setup for the MNAP Suite."
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
    echo "        FSL                 --> FSLFolder=fsl-5.0.9"
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

if [ "$1" == "-help" ]; then
	usage
	exit 0
fi

if [ "$1" == "?help" ]; then
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
# FSL                       Environment Variable --> $FSLFolder
# FIX ICA                   Environment Variable --> $FIXICAFolder
# FreeSurfer                Environment Variable --> $FREESURFERDIR
# FreeSurferScheduler       Environment Variable --> $FreeSurferSchedulerDIR
# workbench                 Environment Variable --> $HCPWBDIR
# PALM                      Environment Variable --> $PALMDIR
# AFNI                      Environment Variable --> $AFNIDIR
# dcm2niix                  Environment Variable --> $DCM2NIIDIR
#
# -------------------------------------------------------------------------------

# -- Check if folders for dependencies are set in the global path
if [[ -z ${FSLFolder} ]]; then unset FSLDIR; FSLFolder="fsl-5.0.9"; fi
if [[ -z ${FIXICAFolder} ]]; then FIXICAFolder="fix1.06"; fi
if [[ -z ${FREESURFERDIR} ]]; then FREESURFERDIR="freesurfer-6.0/freesurfer"; fi
if [[ -z ${FreeSurferSchedulerDIR} ]]; then FreeSurferSchedulerDIR="FreeSurferScheduler"; fi
if [[ -z ${HCPWBDIR} ]]; then HCPWBDIR="workbench"; fi
if [[ -z ${PALMDIR} ]]; then PALMDIR="PALM/PALM"; fi
if [[ -z ${AFNIDIR} ]]; then AFNIDIR="afni_linux_openmp_64"; fi
if [[ -z ${DCM2NIIDIR} ]]; then DCM2NIIDIR="dcm2niix"; fi

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

# -- FreeSurfer path
FREESURFER_HOME=${TOOLS}/${FREESURFERDIR}
PATH=${FREESURFER_HOME}:${PATH}
export FREESURFER_HOME PATH
. ${FREESURFER_HOME}/SetUpFreeSurfer.sh > /dev/null 2>&1

# -- FSL path
# -- Note: Always run after FreeSurfer for correct environment specification
#          because SetUpFreeSurfer.sh can mis-specify the $FSLDIR path 
FSLDIR=${TOOLS}/${FSLFolder}
PATH=${FSLDIR}/bin:${PATH}
. ${FSLDIR}/etc/fslconf/fsl.sh > /dev/null 2>&1
export FSLDIR PATH
MATLABPATH=$FSLDIR:$MATLABPATH
export MATLABPATH

# -- FreeSurfer Scheduler for GPU acceleration path
FREESURFER_SCHEDULER=${TOOLS}/${FreeSurferSchedulerDIR}
PATH=${FREESURFER_SCHEDULER}:${PATH}
export FREESURFER_SCHEDULER PATH

# -- Workbench path (set OS)
if [ "$OperatingSystem" == "Darwin" ]; then
	WORKBENCHDIR=${TOOLS}/${HCPWBDIR}/bin_macosx64
elif [ "$OperatingSystem" == "Linux" ]; then
	WORKBENCHDIR=${TOOLS}/workbench/bin_rh_linux64
fi
PATH=${WORKBENCHDIR}:${PATH}
export WORKBENCHDIR PATH
MATLABPATH=$WORKBENCHDIR:$MATLABPATH
export MATLABPATH

# -- PALM path
PALMPATH=${TOOLS}/${PALMDIR}
PATH=${PALMPATH}:${PATH}
export PALMPATH PATH
MATLABPATH=$PALMPATH:$MATLABPATH
export MATLABPATH

# -- AFNI path
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

# -- Define submodules, but omit hcpextendedpull to avoid conflicts
unset MNAPSubModules
MNAPSubModules=`cd $MNAPPATH; git submodule status | awk '{ print $2 }' | sed 's/hcpextendedpull//' | sed '/^\s*$/d'`

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
# -- MNAP - NIUtilities and Matlab Paths
# ------------------------------------------------------------------------------

# -- Make sure gmri is executable
chmod ugo+x $MNAPPATH/niutilities/gmri &> /dev/null

# -- Setup Python paths
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

# -- Export Python paths
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

# -- Set and export Matlab paths
MATLABPATH=$MNAPPATH/matlab/fcMRI:$MATLABPATH
MATLABPATH=$MNAPPATH/matlab/general:$MATLABPATH
MATLABPATH=$MNAPPATH/matlab/gmri:$MATLABPATH
MATLABPATH=$MNAPPATH/matlab/stats:$MATLABPATH
export MATLABPATH

# ------------------------------------------------------------------------------
# -- Path to additional dependencies
# ------------------------------------------------------------------------------

# -- Define additional paths here as needed

# ------------------------------------------------------------------------------
#  MNAP Functions and git aliases for BitBucket commit and pull requests
# ------------------------------------------------------------------------------

# -- gitmnap_usage function help

gitmnap_usage() {
    echo ""
    echo " -- DESCRIPTION for gitmnap function:"
    echo ""
    echo "The MNAP Suite provides functionality for users with repo privileges to easily pull or commit & push changes via git."
    echo "This is done via two aliases that are setup as general environment variables: "
    echo ""
    echo "    * gitmnap   --> Alias for the MNAP function that updates the MNAP Suite via git from the remote repo or pushes changes to remote repo."
    echo ""
    echo ""
    echo " --command=<git_command>                                            Specify git command: push or pull."
    echo " --branch=<branch_to_work_on>                                       Specify the branch name you want to pull or commit."
    echo " --branchpath=<absolute_path_to_folder_containing_mnap_suite>       This folder has to have the selected branch checked out."
    echo " --message=<commit_message>                                         Specify commit message if running commitmnap"
    echo " --submodules=<list_of_submodules>                                  Comma, space or pipe separated list of submodules to work on."
    echo "                                                                    'all'      --->  Update both the main repo and all submodules"
    echo "                                                                    'main'     --->  Update only the main repo"
    geho "MNAP Submodules:"
    echo ""
    geho "${MNAPSubModules}"
    echo ""
    echo ""
    echo " -- EXAMPLES:"
    echo ""
    echo "gitmnap \ "
    echo "--command='pull' \ "
    echo "--branch='master' \ "
    echo "--branchpath='$TOOLS/$MNAPREPO' \ "
    echo "--submodules='all' "
    echo ""
    echo ""
    echo "gitmnap \ "
    echo "--command='push' \ "
    echo "--branch='master' \ "
    echo "--branchpath='$TOOLS/$MNAPREPO' \ "
    echo "--submodules='all' \ "
    echo "--message='Committing change' "
    echo ""
}

function_gitmnapstatus() {
     # -- Check path
     if [[ -z ${MNAPBranchPath} ]]; then
     	cd $TOOLS/$MNAPREPO
     else
     	cd ${MNAPBranchPath}
     fi
     if [[ ! -z ${MNAPSubModule} ]]; then
		cd ${MNAPBranchPath}/${MNAPSubModule}
     fi
     # -- Update remote
     git remote update > /dev/null 2>&1
     MNAPDirBranchTest=`pwd`
     echo ""
     geho "--- Running git status checks in $MNAPDirBranchTest"
     # -- Set git variables
     unset UPSTREAM; unset LOCAL; unset REMOTE; unset BASE
     UPSTREAM=${1:-'@{u}'}
     LOCAL=$(git rev-parse @)
     REMOTE=$(git rev-parse "$UPSTREAM")
     BASE=$(git merge-base @ "$UPSTREAM")
    # -- Run a few git tests to verify LOCAL, REMOTE and BASE tips
     if [[ $LOCAL == $REMOTE ]]; then
     	echo ""
     	mageho "Note: LOCAL: $LOCAL equals REMOTE: $REMOTE in $MNAPDirBranchTest."
     	echo ""
     elif [[ $LOCAL == $BASE ]]; then
     	echo ""
     	echo "Note: LOCAL: $LOCAL equals BASE: $BASE in ${MNAPDirBranchTest}. You need to pull."
     	echo ""
     elif [[ $REMOTE == $BASE ]]; then
     	echo ""
     	echo "Note: REMOTE: $REMOTE equals BASE: $BASE in ${MNAPDirBranchTest}. You need to push."
     	echo ""
     else
     	echo ""
     	reho "  ERROR: LOCAL, BASE and REMOTE tips have diverged in ${MNAPDirBranchTest}."
     	echo ""
     	reho "              ------------------------------------------------"
     	reho "                 LOCAL: $LOCAL"
     	reho "                 BASE: $BASE"
     	reho "                 REMOTE: $REMOTE"
     	reho "              ------------------------------------------------"
     	echo ""
     	reho "              Check 'git status -uno' to inspect and re-run after cleaning things up."
     	echo ""
     fi
}
alias gitmnapstatus=function_gitmnapstatus

# -- function_gitmnap start
	
function_gitmnap() {

	# -- Inputs
	unset MNAPBranch
	unset MNAPGitCommand
	unset MNAPBranchPath
	unset CommitMessage
	unset GitStatus
	unset MNAPSubModulesList
	MNAPGitCommand=`opts_GetOpt "--command" $@`
	MNAPBranch=`opts_GetOpt "--branch" $@`
	MNAPBranchPath=`opts_GetOpt "--branchpath" $@`
	CommitMessage=`opts_GetOpt "--message" $@`
	MNAPSubModulesList=`opts_GetOpt "--submodules" "$@" | sed 's/,/ /g;s/|/ /g'`; MNAPSubModulesList=`echo "$MNAPSubModulesList" | sed 's/,/ /g;s/|/ /g'` # list of input cases; removing comma or pipes
	
	# -- Check for help calls
	if [[ ${1} == "help" ]] || [[ ${1} == "-help" ]] || [[ ${1} == "--help" ]] || [[ ${1} == "?help" ]] || [[ -z ${1} ]]; then
		gitmnap_usage
		return 0
	fi
	if [[ ${1} == "usage" ]] || [[ ${1} == "-usage" ]] || [[ ${1} == "--usage" ]] || [[ ${1} == "?usage" ]] || [[ -z ${1} ]]; then
		gitmnap_usage
		return 0
	fi
	
	# -- Start execution
	echo ""
	geho "=============== Executing MNAP $MNAPGitCommand function ============== "
	# -- Performing flag checks
	echo ""
	geho "--- Checking inputs ... "
	echo ""
	if [[ -z ${MNAPGitCommand} ]]; then reho ""; reho "   Error: --command flag not defined. Specify 'pull' or 'push' option."; echo ""; gitmnap_usage; return 1; fi
	if [[ -z ${MNAPBranch} ]]; then reho ""; reho "   Error: --branch flag not defined."; echo ""; gitmnap_usage; return 1; fi
	if [[ -z ${MNAPBranchPath} ]]; then reho ""; reho "   Error: --branchpath flag for specified branch not defined. Specify absolute path of the relevant MNAP repo."; echo ""; gitmnap_usage; return 1; fi
	if [[ -z ${MNAPSubModulesList} ]]; then reho ""; reho "   Error: --submodules flag not not defined. Specify 'main', 'all' or specific submodule to commit."; echo ""; gitmnap_usage; return 1; fi
	if [[ ${MNAPSubModulesList} == "all" ]]; then reho ""; geho "   Note: --submodules flag set to all. Setting update for all submodules."; echo ""; fi
	if [[ ${MNAPSubModulesList} == "main" ]]; then reho ""; geho "   Note: --submodules flag set to main MNAP repo only in $MNAPBranchPath"; echo ""; fi
	if [[ ${MNAPGitCommand} == "push" ]]; then
		if [[ -z ${CommitMessage} ]]; then reho ""; reho "   Error: --message flag missing. Please specify commit message."; echo ""; gitmnap_usage; return 1; else CommitMessage="$CommitMessage ${MyID}-via-`hostname`"; fi
	fi

	# -- Perform checks that MNAP contains requested branch and that it is actively checked out
	cd ${MNAPBranchPath}
	echo ""
	mageho "  * Checking active branch for main MNAP repo in $MNAPBranchPath..."
	echo ""
	if [[ -z `git branch | grep "${MNAPBranch}"` ]]; then reho "Error: Branch $MNAPBranch does not exist in $MNAPBranchPath. Check your repo."; echo ""; gitmnap_usage; return 1; else geho "   --> $MNAPBranch found in $MNAPBranchPath"; echo ""; fi
	if [[ -z `git branch | grep "* ${MNAPBranch}"` ]]; then reho "Error: Branch $MNAPBranch is not checked out and active in $MNAPBranchPath. Check your repo."; echo ""; gitmnap_usage; return 1; else geho "   --> $MNAPBranch is active in $MNAPBranchPath"; echo ""; fi
	mageho "  * All checks for main MNAP repo passed."
	echo ""
	
	# -- Not perform further checks
	if [ "${MNAPSubModulesList}" == "main" ]; then
		echo ""
		geho "   Note: --submodules flag set to main MNAP repo only. Omitting individual submodules."
		echo ""
		# -- Check git command
		echo ""
		geho "--- Running MNAP git ${MNAPGitCommand} for ${MNAPBranch} on MNAP main repo in ${MNAPBranchPath}."
		echo
		cd ${MNAPBranchPath}
		# -- Run a few git tests to verify LOCAL, REMOTE and BASE tips
		function_gitmnapstatus > /dev/null 2>&1
		# -- Check git command request
		if [[ ${MNAPGitCommand} == "pull" ]]; then
			cd ${MNAPBranchPath}; git pull origin ${MNAPBranch}
		fi
		if [[ ${MNAPGitCommand} == "push" ]]; then
			cd ${MNAPBranchPath}
			if [[ $LOCAL == $BASE ]] && [[ $LOCAL != $REMOTE ]]; then
				echo ""
				reho " --- LOCAL: $LOCAL equals BASE: $BASE but LOCAL mismatches REMOTE: $REMOTE. You need to pull your changes first. Run 'git status' and inspect changes."
				echo ""
				return 1
			else
				git add ./*
				git commit . --message="${CommitMessage}"
				git push origin ${MNAPBranch}
			fi
		fi
		echo ""
		geho "--- Completed MNAP git ${MNAPGitCommand} for ${MNAPBranch} on MNAP main repo in ${MNAPBranchPath}."; echo ""
		return 1
	fi
	
	# -- Check if all submodules are requested or only specific ones
	if [ ${MNAPSubModulesList} == "all" ]; then
		echo ""
		geho "Note: --submodules flag set to all MNAP repos."
		echo ""
		# -- Reset submodules variable to all
		unset MNAPSubModules
		MNAPSubModules=`cd $MNAPPATH; git submodule status | awk '{ print $2 }' | sed 's/hcpextendedpull//' | sed '/^\s*$/d'`
	fi
	# -- Check specific modules only
	if [[ ${MNAPSubModulesList} != "main" ]]; then 
		if [[ ${MNAPSubModulesList} != "all" ]]; then
		MNAPSubModules=${MNAPSubModulesList}
		echo ""
		geho "Note: --submodules flag set to selected MNAP repos."
		fi
	fi
	
	# -- Continue with specific submodules
	echo ""
	mageho "  * Checking active branch ${MNAPBranch} for specified submodules in ${MNAPBranchPath}... "
	echo ""
	for MNAPSubModule in ${MNAPSubModules}; do
		cd ${MNAPBranchPath}/${MNAPSubModule}
		if [[ -z `git branch | grep "${MNAPBranch}"` ]]; then reho "Error: Branch $MNAPBranch does not exist in $MNAPBranchPath/$MNAPSubModule. Check your repo."; echo ""; gitmnap_usage; return 1; else geho "--> $MNAPBranch found in $MNAPBranchPath/$MNAPSubModule"; echo ""; fi
		if [[ -z `git branch | grep "* ${MNAPBranch}"` ]]; then reho "Error: Branch $MNAPBranch is not checked out and active in $MNAPBranchPath/$MNAPSubModule. Check your repo."; echo ""; gitmnap_usage; return 1; else geho "--> $MNAPBranch is active in $MNAPBranchPath/$MNAPSubModule"; echo ""; fi
	done
	mageho "  * All checks passed for specified submodules... "
	echo ""
	# -- First run over specific modules
	for MNAPSubModule in ${MNAPSubModules}; do
		echo ""
		geho "--- Running MNAP git ${MNAPGitCommand} for ${MNAPBranch} on MNAP submodule ${MNAPBranchPath}/${MNAPSubModule}."
		echo
		cd ${MNAPBranchPath}/${MNAPSubModule}
		# -- Run a few git tests to verify LOCAL, REMOTE and BASE tips
		function_gitmnapstatus > /dev/null 2>&1
		# -- Check git command requests
		if [[ ${MNAPGitCommand} == "pull" ]]; then
			cd ${MNAPBranchPath}/${MNAPSubModule}; git pull origin ${MNAPBranch}
		fi
		if [[ ${MNAPGitCommand} == "push" ]]; then
			if [[ $LOCAL == $BASE ]] && [[ $LOCAL != $REMOTE ]]; then
				echo ""
				reho " --- LOCAL: $LOCAL equals BASE: $BASE but LOCAL mismatches REMOTE: $REMOTE. You need to pull your changes first. Run 'git status' and inspect changes."
				echo ""
				return 1
			else
				cd ${MNAPBranchPath}/${MNAPSubModule}
				git add ./*
				git commit . --message="${CommitMessage}"
				git push origin ${MNAPBranch}
			fi
		fi
		echo ""
		geho "--- Completed MNAP git ${MNAPGitCommand} for ${MNAPBranch} on MNAP submodule ${MNAPBranchPath}/${MNAPSubModule}."; echo ""; echo ""
	done
	unset MNAPSubModule
	
	# -- Finish up with the main submodule after individual modules are committed
	echo ""
	geho "--- Running MNAP git ${MNAPGitCommand} for ${MNAPBranch} on MNAP main repo in ${MNAPBranchPath}."
	echo
	cd ${MNAPBranchPath}
	function_gitmnapstatus
	# -- Check git command request
	if [[ ${MNAPGitCommand} == "pull" ]]; then
		cd ${MNAPBranchPath}; git pull origin ${MNAPBranch}
	fi
	if [[ ${MNAPGitCommand} == "push" ]]; then
		cd ${MNAPBranchPath}
			if [[ $LOCAL == $BASE ]] && [[ $LOCAL != $REMOTE ]]; then
			echo ""
				reho " --- LOCAL: $LOCAL equals BASE: $BASE but LOCAL mismatches REMOTE: $REMOTE. You need to pull your changes first. Run 'git status' and inspect changes."
			echo ""
			return 1
		else
			git add ./*
			git commit . --message="${CommitMessage}"
			git push origin ${MNAPBranch}
		fi
	fi
	
	echo ""
	geho "--- Completed MNAP git ${MNAPGitCommand} for ${MNAPBranch} on MNAP main repo in ${MNAPBranchPath}."; echo ""
	
	# -- Report final completion
	echo ""
	geho "=============== Completed MNAP $MNAPGitCommand function ============== "
	echo ""

	# -- Reset submodules variable
	unset MNAPSubModules
	MNAPSubModules=`cd $MNAPPATH; git submodule status | awk '{ print $2 }' | sed 's/hcpextendedpull//' | sed '/^\s*$/d'`
	unset MNAPBranch
	unset MNAPGitCommand
	unset MNAPBranchPath
	unset CommitMessage
	unset GitStatus
	unset MNAPSubModulesList
	unset MNAPSubModule
}

# -- define function_gitmnap alias
alias gitmnap=function_gitmnap

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
