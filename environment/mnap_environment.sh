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
    echo "  TOOLS                              --> The base folder for the dependency installation "
    echo "  │ "
    echo "  ├── mnaptools                       --> Env. Variable => MNAPREPO -- All MNAP Suite repositories (https://bitbucket.org/hidradev/mnaptools) "
    echo "  │ "
    echo "  ├── HCPpipelines                    --> Human Connectome Pipelines Folder (https://github.com/Washington-University/HCPpipelines) "
    echo "  │   ├── HCPpipelines-stable         --> Env. Variable => HCPPIPEDIR  Note: Only Human Connectome Pipelines Stable Branch is set by default "
    echo "  │   ├── HCPpipelines-<VERSION>      --> Point any other desired version point to HCPPIPEDIR "
    echo "  │   └── HCPpipelinesRunUtils        --> Env. Variable => HCPPIPERUNUTILS "
    echo "  │ "
    echo "  ├── fmriprep                        --> fMRIPrep Pipelines (https://github.com/poldracklab/fmriprep) "
    echo "  │   ├── fmriprep-latest             --> Env. Variable => FMRIPREPDIR "
    echo "  │   └── fmriprep-<VERSION>          --> Set any other version to FMRIPREPDIR "
    echo "  │ "
    echo "  ├── afni                            --> AFNI: Analysis of Functional NeuroImages (https://github.com/afni/afni) "
    echo "  │   └── afni-latest                 --> Env. Variable => AFNIDIR "
    echo "  │ "
    echo "  ├── dcm2niix                        --> dcm2niix conversion tool (https://github.com/rordenlab/dcm2niix) "
    echo "  │   └── dcm2niix-latest             --> Env. Variable => DCMNIIDIR "
    echo "  │ "
    echo "  ├── dicm2nii                        --> dicm2nii conversion tool (https://github.com/xiangruili/dicm2nii) "
    echo "  │   └── dicm2nii-latest             --> Env. Variable => DICMNIIDIR "
    echo "  │ "
    echo "  ├── freesurfer                      --> FreeSurfer (http://ftp.nmr.mgh.harvard.edu/pub/dist/freesurfer/5.3.0-HCP/) "
    echo "  │   └── freesurfer-5.3-HCP          --> Env. Variable => FREESURFER_HOME (v5.3-HCP version for HCP-compatible data) "
    echo "  │   └── freesurfer-<VERSION>        --> Env. Variable => FREESURFER_HOME (v6.0 or later stable for all other data) "
    echo "  │   └── FreeSurferScheduler         --> Env. Variable => FreeSurferSchedulerDIR "
    echo "  │ "
    echo "  ├── fsl                             --> FSL (v5.0.9 or above with GPU-enabled DWI tools; https://fsl.fmrib.ox.ac.uk/fsl/fslwiki) "
    echo "  │   └── fsl-latest                  --> Env. Variable => FSLDIR "
    echo "  │   └── fix-latest                  --> Env. Variable => FSL_FIXDIR -- ICA FIX (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FIX/UserGuide) "
    echo "  │ "
    echo "  ├── matlab                          --> Matlab vR2017b or higher. If Matlab is installed system-wide then a symlink is created here "
    echo "  │   └── matlab-latest               --> Env. Variable => MATLABDIR "
    echo "  │   └── matlab-latest/bin           --> Env. Variable => MATLABBINDIR "
    echo "  │ "
    echo "  ├── octave                          --> Octave v.4.4.1 or higher. If Octave is installed system-wide then a symlink is created here "
    echo "  │   └── octave-latest               --> Env. Variable => OCTAVEDIR "
    echo "  │   └── octave-latest/bin           --> Env. Variable => OCTAVEBINDIR "
    echo "  │   └── octavepkg                   --> Env. Variable => OCTAVEPKGDIR -- If Octave packages need manual deployment then the installed packages go here "
    echo "  │ "
    echo "  ├── palm                            --> PALM: Permutation Analysis of Linear Models (https://github.com/andersonwinkler/PALM) "
    echo "  │   └── palm-latest-o               --> Env. Variable => PALMDIR (If using Octave) "
    echo "  │   └── palm-latest-m               --> Env. Variable => PALMDIR (If using Matlab) "
    echo "  │   └── palm-<VERSION>              --> Set any other version to PALMDIR " 
    echo "  │ "
    echo "  ├── R                               --> R Statistical computing environment"
    echo "  │   └── R-latest                    --> Env. Variable => RDIR "
    echo "  │ "
    echo "  ├── pylib                           --> Env. Variable => PYLIBDIR      -- All MNAP python libraries and tools "
    echo "  │   ├── gradunwarp                  --> Env. Variable => GRADUNWARPDIR -- HCP version of gradunwarp (https://github.com/Washington-University/gradunwarp) "
    echo "  │   ├── nibabel                     --> Env. Variable => NIBABELDIR    -- NiBabel (http://nipy.org/nibabel/) "
    echo "  │   └── pydicom                     --> Env. Variable => PYDICOMDIR    -- pydicom (v1.1.0 or later; https://pydicom.github.io) "
    echo "  │ "
    echo "  └── workbench/workbench-<VERSION>   Connectome Workbench (v1.0 or above; https://www.humanconnectome.org/software/connectome-workbench) "
    echo "      └── workbench-<VERSION>         Env. Variable = HCPWBDIR "
    echo ""
    echo " These defaults can be redefined if the above paths are declared as global variables in the .bash_profile profile after loading the MNAP environment."
    echo ""
    geho "  ==> For full environment report run 'mnap environment'"
    echo ""
    exit 0
}

if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "?help" ] || [ "$1" == "--usage" ] || [ "$1" == "-usage" ] || [ "$1" == "usage" ] || [ "$1" == "?usage" ]; then
    usage
fi

# ------------------------------------------------------------------------------
#  Environment clear and check functions
# ------------------------------------------------------------------------------

ENVVARIABLES='MNAPVer TOOLS MNAPREPO MNAPPATH TemplateFolder FSL_FIXDIR POSTFIXICADIR FREESURFERDIR FREESURFER_HOME FREESURFER_SCHEDULER FreeSurferSchedulerDIR WORKBENCHDIR DCMNIIDIR DICMNIIDIR MATLABDIR MATLABBINDIR OCTAVEDIR OCTAVEPKGDIR OCTAVEBINDIR RDIR HCPWBDIR AFNIDIR PYLIBDIR FSLDIR FSLGPUDIR PALMDIR GRADUNWARPDIR MNAPMCOMMAND HCPPIPEDIR CARET7DIR GRADUNWARPDIR HCPPIPEDIR_Templates HCPPIPEDIR_Bin HCPPIPEDIR_Config HCPPIPEDIR_PreFS HCPPIPEDIR_FS HCPPIPEDIR_PostFS HCPPIPEDIR_fMRISurf HCPPIPEDIR_fMRIVol HCPPIPEDIR_tfMRI HCPPIPEDIR_dMRI HCPPIPEDIR_dMRITract HCPPIPEDIR_Global HCPPIPEDIR_tfMRIAnalysis MSMBin HCPPIPEDIR_dMRITracFull HCPPIPEDIR_dMRILegacy AutoPtxFolder FSLGPUBinary EDDYCUDADIR'
export ENVVARIABLES

# -- Check if inside the container and reset the environment on first setup
if [[ -f /opt/.container ]]; then
    # -- Perform initial reset for the environment in the container
    if [[ "$FIRSTRUNDONE" != "TRUE" ]]; then
        unset $ENVVARIABLES
        TOOLS="/opt"
        PATH=${TOOLS}:${PATH}
        export TOOLS PATH
        export FIRSTRUNDONE="TRUE"
    fi
    # -- Check for specific settings a user might want:
    # if [ -f ~/.mnap_container.rc ]; then         # --- This is a file that should reside in a user's home folder and it should contain the settings the user want's to make that are different from the defaults.
    #     bash ~/.mnap_container.rc
    # elif [[ ! -z "$MNAPCONTAINERENV" ]]; then    # --- This is an environmental variable that if set should hold a path to a bash script that contains the settings the user want's to make that are different from the defaults.
    #     bash $MNAPCONTAINERENV
    # fi
fi

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= CODE START =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=

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
OperatingSystem=`uname -sv`
if [[ `gcc --version | grep 'darwin'` != "" ]]; then OSInfo="Darwin"; else
    if [[ `cat /etc/*-release | grep 'Red Hat'` != "" ]] || [[ `cat /etc/*-release | grep 'rhel'` != "" ]]; then OSInfo="RedHat";
        elif [[ `cat /etc/*-release| grep 'ubuntu'` != "" ]]; then OSInfo="Ubuntu";
            elif [[ `cat /etc/*-release | grep 'debian'` != "" ]]; then OSInfo="Debian";
    fi
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
# -- MNAP - General Code
# ------------------------------------------------------------------------------

if [ -z ${MNAPREPO} ]; then
    MNAPREPO="mnaptools"
fi

# ---- changed to work with new clone/branches setup

if [ -e ~/mnapinit.sh ]; then
    source ~/mnapinit.sh
fi

MNAPPATH=${TOOLS}/${MNAPREPO}
MNAPVer=`cat ${TOOLS}/${MNAPREPO}/VERSION.md`
export MNAPPATH MNAPREPO MNAPVer

if [ -e ~/mnapinit.sh ]; then
    echo ""
    reho " --- NOTE: MNAP is set by your ~/mnapinit.sh file! ----"
    echo ""
    reho " ---> MNAP path is set to: ${MNAPPATH} "
    echo ""
fi

# ------------------------------------------------------------------------------
# -- Load dependent software
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# -- Set default folder names for dependencies if undefined by user environment:
# ------------------------------------------------------------------------------

# -- Check if folders for dependencies are set in the global path
if [[ -z ${FSLDIR} ]]; then FSLDIR="${TOOLS}/fsl/fsl-latest"; export FSLDIR; fi
if [[ -z ${FSL_FIXDIR} ]]; then FSL_FIXDIR="${TOOLS}/fsl/fix-latest"; fi
if [[ -z ${FREESURFERDIR} ]]; then FREESURFERDIR="${TOOLS}/freesurfer/freesurfer-5.3-HCP"; export FREESURFERDIR; fi
if [[ -z ${FreeSurferSchedulerDIR} ]]; then FreeSurferSchedulerDIR="${TOOLS}/freesurfer/FreeSurferScheduler"; export FreeSurferSchedulerDIR; fi
if [[ -z ${HCPWBDIR} ]]; then HCPWBDIR="${TOOLS}/workbench/workbench-latest"; export HCPWBDIR; fi
if [[ -z ${AFNIDIR} ]]; then AFNIDIR="${TOOLS}/afni/afni-latest"; export AFNIDIR; fi
if [[ -z ${DCMNIIDIR} ]]; then DCMNIIDIR="${TOOLS}/dcm2niix/dcm2niix-latest"; export DCMNIIDIR; fi
if [[ -z ${DICMNIIDIR} ]]; then DICMNIIDIR="${TOOLS}/dicm2nii/dicm2nii-latest"; export DICMNIIDIR; fi
if [[ -z ${OCTAVEDIR} ]]; then OCTAVEDIR="${TOOLS}/octave/octave-latest"; export OCTAVEDIR; fi
if [[ -z ${OCTAVEPKGDIR} ]]; then OCTAVEPKGDIR="${TOOLS}/octave/octavepkg"; export OCTAVEPKGDIR; fi
if [[ -z ${PYLIBDIR} ]]; then PYLIBDIR="${TOOLS}/pylib"; export PYLIBDIR; fi
if [[ -z ${HCPPIPEDIR} ]]; then HCPPIPEDIR="${TOOLS}/${MNAPREPO}/hcpmodified"; export HCPPIPEDIR; fi
if [[ -z ${FMRIPREPDIR} ]]; then FMRIPREPDIR="${TOOLS}/fmriprep/fmriprep-latest"; export FMRIPREPDIR; fi
if [[ -z ${MATLABDIR} ]]; then MATLABDIR="${TOOLS}/matlab/matlab-latest"; export MATLABDIR; fi
if [[ -z ${RDIR} ]]; then RDIR="${TOOLS}/R/R-latest"; export RDIR; fi

# -- Checks for version
showVersion() {
    MNAPVer=`cat ${TOOLS}/${MNAPREPO}/VERSION.md`
    echo ""
    geho " Loading Multimodal Neuroimaging Analysis Platform (MNAP) Suite Version: v${MNAPVer}"
}

# ------------------------------------------------------------------------------
# -- License and version disclaimer
# ------------------------------------------------------------------------------

showVersion
geho ""
geho " Logged in as User: $MyID                                                    "
geho " Node info: `hostname`                                                       "
geho " OS: $OSInfo $OperatingSystem                                                "
geho ""
geho "                  ███╗   ███╗███╗   ██╗ █████╗ ██████╗                       "
geho "                  ████╗ ████║████╗  ██║██╔══██╗██╔══██╗                      "
geho "                  ██╔████╔██║██╔██╗ ██║███████║██████╔╝                      "
geho "                  ██║╚██╔╝██║██║╚██╗██║██╔══██║██╔═══╝                       "
geho "                  ██║ ╚═╝ ██║██║ ╚████║██║  ██║██║                           "
geho "                  ╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝                           "
geho ""
geho "                     DEVELOPED & MAINTAINED BY: "
geho ""
geho "                            Anticevic Lab                                    " 
geho "                       MBLab led by Grega Repovs                             "
geho ""
geho "                      COPYRIGHT & LICENSE NOTICE:                            "
geho ""
geho "Use of this software is subject to the terms and conditions defined by the   "
geho " Yale University Copyright Policies:"
geho "    http://ocr.yale.edu/faculty/policies/yale-university-copyright-policy    "
geho " and the terms and conditions defined in the file 'LICENSE.md' which is      "
geho " a part of the MNAP Suite source code package:"
geho "    https://bitbucket.org/hidradev/mnaptools/src/master/LICENSE.md"
geho ""

# ------------------------------------------------------------------------------
#  Check for Lmod and Load software modules -- deprecated to ensure container compatibility
# ------------------------------------------------------------------------------

# -- Check if Lmod is installed and if Matlab is available https://lmod.readthedocs.io/en/latest/index.html
#    Lmod is a Lua based module system that easily handles the MODULEPATH Hierarchical problem.
# if [[ `module -t --redirect help | grep 'Lua'` = *"Lua"* ]]; then LMODPRESENT="yes"; else LMODPRESENT="no"; fi > /dev/null 2>&1
# if [[ ${LMODPRESENT} == "yes" ]]; then
#     module load StdEnv &> /dev/null
#     # -- Check for presence of system install via Lmod
#     if [[ `module -t --redirect avail /Matlab` = *"matlab"* ]] || [[ `module -t --redirect avail /Matlab` = *"Matlab"* ]]; then LMODMATLAB="yes"; else LMODMATLAB="no"; fi > /dev/null 2>&1
#     if [[ `module -t --redirect avail /Matlab` = *"octave"* ]] || [[ `module -t --redirect avail /Octave` = *"Octave"* ]]; then LMODOCTAVE="yes"; else LMODOCTAVE="no"; fi > /dev/null 2>&1
#     # --- Matlab vs Octave
#     if [ -f ~/.mnapuseoctave ] && [[ ${LMODOCTAVE} == "yes" ]]; then
#         module load Libs/netlib &> /dev/null
#         module load Apps/Octave/4.2.1 &> /dev/null
#         echo ""; cyaneho " ---> Selected to use Octave instead of Matlab! "
#         OctaveTest="pass"
#     fi
#     if [ -f ~/.mnapuseoctave ] && [[ ${LMODOCTAVE} == "no" ]]; then
#         echo ""; reho " ===> ERROR: .mnapuseoctave set but no Octave module is present on the system."; echo ""
#         OctaveTest="fail"
#     fi
#     if [ ! -f ~/.mnapuseoctave ] && [[ ${LMODMATLAB} == "yes" ]]; then
#         module load Apps/Matlab/R2018a &> /dev/null
#         echo ""; cyaneho " ---> Selected to use Matlab!"
#         MatlabTest="pass"
#     fi
#     if [ ! -f ~/.mnapuseoctave ] && [[ ${LMODMATLAB} == "no" ]]; then
#         echo ""; reho " ===> ERROR: Matlab selected and Lmod found but Matlab module missing. Alert your SysAdmin"; echo ""
#         MatlabTest="fail"
#     fi
# fi

# ------------------------------------------------------------------------------
# -- Running matlab vs. octave
# ------------------------------------------------------------------------------

if [ -f ~/.mnapuseoctave ]; then
    if [[ ${OctaveTest} == "fail" ]]; then 
        reho " ===> ERROR: Cannot setup Octave because module test failed."
    else
         ln -s `which octave` ${OCTAVEDIR}/octave > /dev/null 2>&1
         export OCTAVEPKGDIR
         export OCTAVEDIR
         export OCTAVEBINDIR
         cyaneho " ---> Setting up Octave "; echo ""
         MNAPMCOMMAND='octave -q --eval'
         if [ ! -e ~/.octaverc ]; then
             cp ${MNAPPATH}/library/.octaverc ~/.octaverc
         fi
         export LD_LIBRARY_PATH=/usr/lib64/hdf5/:LD_LIBRARY_PATH > /dev/null 2>&1
         if [[ -z ${PALMDIR} ]]; then PALMDIR="${TOOLS}/palm/palm-latest-o"; fi
    fi
fi
if [ ! -f ~/.mnapuseoctave ]; then 
    # if [[ ${MatlabTest} == "fail" ]]; then
    #     reho " ===> ERROR: Cannot setup Matlab because module test failed."
    # else
         
         cyaneho " ---> Setting up Matlab "; echo ""
         MNAPMCOMMAND='matlab -nodisplay -nosplash -r'
         if [[ -z ${PALMDIR} ]]; then PALMDIR="${TOOLS}/palm/palm-latest-m"; fi
    # fi
fi
# -- Use the following command to run .m code in Matlab
export MNAPMCOMMAND

# ------------------------------------------------------------------------------
#  path to additional libraries
# ------------------------------------------------------------------------------

LD_LIBRARY_PATH=$TOOLS/lib:$TOOLS/lib/lib:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=/usr/lib64/hdf5:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=$TOOLS/olib:$LD_LIBRARY_PATH
PKG_CONFIG_PATH=$TOOLS/lib/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH
export PKG_CONFIG_PATH
PATH=$TOOLS/bin:$TOOLS/lib/bin:$TOOLS/lib/lib/:$PATH
export PATH

# -- FSL probtrackx2_gpu command path
FSLGPUDIR=${FSLDIR}/bin
PATH=${FSLGPUDIR}:${PATH}
export FSLGPUDIR PATH
MATLABPATH=$FSLGPUDIR:$MATLABPATH
export MATLABPATH

# -- FreeSurfer path
FREESURFER_HOME=${FREESURFERDIR}
PATH=${FREESURFER_HOME}:${PATH}
export FREESURFER_HOME PATH
. ${FREESURFER_HOME}/SetUpFreeSurfer.sh > /dev/null 2>&1

# -- FSL path
# -- Note: Always run after FreeSurfer for correct environment specification
#          because SetUpFreeSurfer.sh can mis-specify the $FSLDIR path
PATH=${FSLDIR}/bin:${PATH}
. ${FSLDIR}/etc/fslconf/fsl.sh > /dev/null 2>&1
export FSLDIR PATH
MATLABPATH=$FSLDIR:$MATLABPATH
export MATLABPATH

# -- FreeSurfer Scheduler for GPU acceleration path
FREESURFER_SCHEDULER=${FreeSurferSchedulerDIR}
PATH=${FREESURFER_SCHEDULER}:${PATH}
export FREESURFER_SCHEDULER PATH

# -- Workbench path (set OS)
if [ "$OSInfo" == "Darwin" ]; then
    WORKBENCHDIR=${HCPWBDIR}/bin_macosx64
elif [ "$OSInfo" == "Ubuntu" ] || [ "$OSInfo" == "Debian" ]; then
    WORKBENCHDIR=${HCPWBDIR}/bin_linux64
elif [ "$OSInfo" == "RedHat" ]; then
    WORKBENCHDIR=${HCPWBDIR}/bin_rh_linux64
fi
PATH=${WORKBENCHDIR}:${PATH}
export WORKBENCHDIR PATH
MATLABPATH=$WORKBENCHDIR:$MATLABPATH
export MATLABPATH

# -- PALM path
PATH=${PALMDIR}:${PATH}
export PALMDIR PATH
MATLABPATH=$PALMDIR:$MATLABPATH
export MATLABPATH

# -- AFNI path
PATH=${AFNIDIR}:${PATH}
export AFNIDIR PATH
MATLABPATH=$AFNIDIR:$MATLABPATH
export MATLABPATH

# -- dcm2niix path
DCMNIIBINDIR=${DCMNIIDIR}/build/bin
PATH=${DCMNIIDIR}:${DCMNIIBINDIR}:${PATH}
export DCMNIIDIR PATH

# -- dicm2nii path
export DICMNIIDIR PATH
MATLABPATH=$DICMNIIDIR:$MATLABPATH
export MATLABPATH

# -- Octave path
OCTAVEBINDIR=${OCTAVEDIR}/bin
PATH=${OCTAVEBINDIR}:${PATH}
export OCTAVEBINDIR PATH

# -- Matlab path
MATLABBINDIR=${MATLABDIR}/bin
PATH=${MATLABBINDIR}:${PATH}
export MATLABBINDIR PATH

# -- R path
PATH=${RDIR}:${PATH}
export RDIR PATH

# ------------------------------------------------------------------------------
# -- Setup overall MNAP paths
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

alias mnap='bash ${TOOLS}/${MNAPREPO}/connector/mnap.sh'
alias mnap_envset='source ${TOOLS}/${MNAPREPO}/library/environment/mnap_environment.sh'
alias mnap_environment_set='source ${TOOLS}/${MNAPREPO}/library/environment/mnap_environment.sh'

alias mnap_envhelp='bash ${TOOLS}/${MNAPREPO}/library/environment/mnap_environment.sh --help'
alias mnap_environment_help='bash ${TOOLS}/${MNAPREPO}/library/environment/mnap_environment.sh --help'

alias mnap_envcheck='source ${TOOLS}/${MNAPREPO}/library/environment/mnap_envStatus.sh --envstatus'
alias mnap_envstatus='source ${TOOLS}/${MNAPREPO}/library/environment/mnap_envStatus.sh --envstatus'
alias mnap_envreport='source ${TOOLS}/${MNAPREPO}/library/environment/mnap_envStatus.sh --envstatus'
alias mnap_environment_check='source ${TOOLS}/${MNAPREPO}/library/environment/mnap_envStatus.sh --envstatus'
alias mnap_environment_status='source ${TOOLS}/${MNAPREPO}/library/environment/mnap_envStatus.sh --envstatus'
alias mnap_environment_report='source ${TOOLS}/${MNAPREPO}/library/environment/mnap_envStatus.sh --envstatus'

alias mnap_envreset='source ${TOOLS}/${MNAPREPO}/library/environment/mnap_envStatus.sh --envclear'
alias mnap_envclear='source ${TOOLS}/${MNAPREPO}/library/environment/mnap_envStatus.sh --envclear'
alias mnap_envpurge='source ${TOOLS}/${MNAPREPO}/library/environment/mnap_envStatus.sh --envclear'
alias mnap_environment_reset='source ${TOOLS}/${MNAPREPO}/library/environment/mnap_envStatus.sh --envclear'
alias mnap_environment_clear='source ${TOOLS}/${MNAPREPO}/library/environment/mnap_envStatus.sh --envclear'
alias mnap_environment_purge='source ${TOOLS}/${MNAPREPO}/library/environment/mnap_envStatus.sh --envclear'

# ------------------------------------------------------------------------------
# -- Setup HCP Pipeline paths
# ------------------------------------------------------------------------------

# -- Re-Set HCP Pipeline path to different version if needed 
if [ -e ~/.mnaphcpe ];
    then
    HCPPIPEDIR=${TOOLS}/${MNAPREPO}/hcpextendedpull
    echo ""
    reho " ===> NOTE: You are in MNAP HCP development mode!"
    reho " ---> MNAP HCP path is set to: $HCPPIPEDIR"
    echo ""
fi

# -- Export HCP Pipeline and relevant variables
export PATH=${HCPPIPEDIR}:${PATH}; export PATH
export CARET7DIR=$WORKBENCHDIR; PATH=${CARET7DIR}:${PATH}; export PATH
export GRADUNWARPDIR=$PYLIBDIR/gradunwarp/core; PATH=${GRADUNWARPDIR}:${PATH}; export PATH
export HCPPIPEDIR_Templates=${HCPPIPEDIR}/global/templates; PATH=${HCPPIPEDIR_Templates}:${PATH}; export PATH
export HCPPIPEDIR_Bin=${HCPPIPEDIR}/global/binaries; PATH=${HCPPIPEDIR_Bin}:${PATH}; export PATH
export HCPPIPEDIR_Config=${HCPPIPEDIR}/global/config; PATH=${HCPPIPEDIR_Config}:${PATH}; export PATH
export HCPPIPEDIR_PreFS=${HCPPIPEDIR}/PreFreeSurfer/scripts; PATH=${HCPPIPEDIR_PreFS}:${PATH}; export PATH
export HCPPIPEDIR_FS=${HCPPIPEDIR}/FreeSurfer/scripts; PATH=${HCPPIPEDIR_FS}:${PATH}; export PATH
export HCPPIPEDIR_PostFS=${HCPPIPEDIR}/PostFreeSurfer/scripts; PATH=${HCPPIPEDIR_PostFS}:${PATH}; export PATH
export HCPPIPEDIR_fMRISurf=${HCPPIPEDIR}/fMRISurface/scripts; PATH=${HCPPIPEDIR_fMRISurf}:${PATH}; export PATH
export HCPPIPEDIR_fMRIVol=${HCPPIPEDIR}/fMRIVolume/scripts; PATH=${HCPPIPEDIR_fMRIVol}:${PATH}; export PATH
export HCPPIPEDIR_tfMRI=${HCPPIPEDIR}/tfMRI/scripts; PATH=${HCPPIPEDIR_tfMRI}:${PATH}; export PATH
export HCPPIPEDIR_dMRI=${HCPPIPEDIR}/DiffusionPreprocessing/scripts; PATH=${HCPPIPEDIR_dMRI}:${PATH}; export PATH
export HCPPIPEDIR_dMRITract=${HCPPIPEDIR}/DiffusionTractography/scripts; PATH=${HCPPIPEDIR_dMRITract}:${PATH}; export PATH
export HCPPIPEDIR_Global=${HCPPIPEDIR}/global/scripts; PATH=${HCPPIPEDIR_Global}:${PATH}; export PATH
export HCPPIPEDIR_tfMRIAnalysis=${HCPPIPEDIR}/TaskfMRIAnalysis/scripts; PATH=${HCPPIPEDIR_tfMRIAnalysis}:${PATH}; export PATH
export MSMBin=${HCPPIPEDIR}/MSMBinaries; PATH=${MSMBin}:${PATH}; export PATH
export HCPPIPEDIR_dMRITracFull=${HCPPIPEDIR}/DiffusionTractographyDense; PATH=${HCPPIPEDIR_dMRITracFull}:${PATH}; export PATH
export HCPPIPEDIR_dMRILegacy=${TOOLS}/${MNAPREPO}/connector/functions; PATH=${HCPPIPEDIR_dMRILegacy}:${PATH}; export PATH
export AutoPtxFolder=${HCPPIPEDIR_dMRITracFull}/autoPtx_HCP_extended; PATH=${AutoPtxFolder}:${PATH}; export PATH
export FSLGPUBinary=${HCPPIPEDIR_dMRITracFull}/fsl_gpu_binaries; PATH=${FSLGPUBinary}:${PATH}; export PATH
export EDDYCUDADIR=${FSLGPUBinary}/eddy_cuda; PATH=${EDDYCUDADIR}:${PATH}; export PATH; eddy_cuda="eddy_cuda_wQC"; export eddy_cuda

# --- HCPPipelines specific settings --- TO BE EDITED FURTHER
export MATLAB_COMPILER_RUNTIME=DUMMYVarianbleNotUsedCurrently
export MSMBINDIR="DUMMYVarianbleNotUsedCurrently"
export MSMCONFIGDIR=${HCPPIPEDIR}/MSMConfig; PATH=${MSMCONFIGDIR}:${PATH}; export PATH


# ------------------------------------------------------------------------------
# -- Setup ICA FIX paths and variables
# ------------------------------------------------------------------------------

# -- ICA FIX path
PATH=${FSL_FIXDIR}:${PATH}
export FSL_FIXDIR PATH
MATLABPATH=$FSL_FIXDIR:$MATLABPATH
export MATLABPATH
if [ ! -z `which matlab 2>/dev/null` ]; then
    MATLABBIN=$(dirname `which matlab 2>/dev/null`)
fi
export MATLABBIN
MATLABROOT=`cd $MATLABBIN; cd ..; pwd`
export MATLABROOT

# -- Setup HCP Pipelines global matlab path relevant for FIX ICA
HCPDIRMATLAB=${HCPPIPEDIR}/global/matlab/
export HCPDIRMATLAB
PATH=${HCPDIRMATLAB}:${PATH}
MATLABPATH=$HCPDIRMATLAB:$MATLABPATH
export MATLABPATH
export PATH

# -- FIX ICA Dependencies Folder
FIXDIR_DEPEND=${MNAPPATH}/library/etc/ICAFIXDependencies
export FIXDIR_DEPEND
PATH=${FIXDIR_DEPEND}:${PATH}
MATLABPATH=$FIXDIR_DEPEND:$MATLABPATH
export MATLABPATH

# -- Setup MATLAB_GIFTI_LIB relevant for FIX ICA
MATLAB_GIFTI_LIB=$FIXDIR_DEPEND/gifti/
export MATLAB_GIFTI_LIB
PATH=${MATLAB_GIFTI_LIB}:${PATH}
MATLABPATH=$MATLAB_GIFTI_LIB:$MATLABPATH
export MATLABPATH
export PATH
#. ${FIXDIR_DEPEND}/ICAFIX_settings.sh > /dev/null 2>&1 

# -- POST FIX ICA path
POSTFIXICADIR=${TOOLS}/${MNAPREPO}/hcpmodified/PostFix
PATH=${POSTFIXICADIR}:${PATH}
export POSTFIXICADIR PATH
MATLABPATH=$POSTFIXICADIR:$MATLABPATH
export MATLABPATH

# ------------------------------------------------------------------------------
# -- MNAP - NIUtilities and Matlab Paths
# ------------------------------------------------------------------------------

# -- Make sure gmri is executable
chmod ugo+x $MNAPPATH/niutilities/gmri &> /dev/null

# -- Setup additional paths
PATH=$MNAPPATH/connector:$PATH
PATH=$MNAPPATH/niutilities:$PATH
PATH=$MNAPPATH/matlab:$PATH
PATH=$TOOLS/bin:$PATH
PATH=$PYLIBDIR/gradunwarp:$PATH
PATH=$PYLIBDIR/gradunwarp/core:$PATH
PATH=$PYLIBDIR/xmlutils.py:$PATH
PATH=$PYLIBDIR:$PATH
PATH=$PYLIBDIR/bin:$PATH
PATH=$TOOLS/MeshNet:$PATH
PATH=/usr/local/bin:$PATH
PATH=$PATH:/bin
PATH=$TOOLS/olib:$PATH

# -- Export Python paths
PYTHONPATH=$TOOLS:$PYTHONPATH
PYTHONPATH=$TOOLS/pylib:$PYTHONPATH
PYTHONPATH=/usr/local/bin:$PYTHONPATH
PYTHONPATH=/usr/local/bin/python2.7:$PYTHONPATH
PYTHONPATH=/usr/lib/python2.7/site-packages:$PYTHONPATH
PYTHONPATH=/usr/lib64/python2.7/site-packages:$PYTHONPATH
PYTHONPATH=$MNAPPATH:$PYTHONPATH
PYTHONPATH=$MNAPPATH/connector:$PYTHONPATH
PYTHONPATH=$MNAPPATH/niutilities:$PYTHONPATH
PYTHONPATH=$MNAPPA$TH/matlab:$PYTHONPATH
PYTHONPATH=$PYLIBDIR/pydicom:$PYTHONPATH
PYTHONPATH=$PYLIBDIR/gradunwarp:$PYTHONPATH
PYTHONPATH=$PYLIBDIR/gradunwarp/core:$PYTHONPATH
PYTHONPATH=$PYLIBDIR/xmlutils.py:$PYTHONPATH
PYTHONPATH=$PYLIBDIR/bin:$PYTHONPATH
PYTHONPATH=$PYLIBDIR/lib/python2.7/site-packages:$PYTHONPATH
PYTHONPATH=$PYLIBDIR/lib64/python2.7/site-packages:$PYTHONPATH
PYTHONPATH=$PYLIBDIR:$PYTHONPATH
PYTHONPATH=$TOOLS/MeshNet:$PYTHONPATH
export PATH
export PYTHONPATH

# -- Set and export Matlab paths
MATLABPATH=$MNAPPATH/matlab/fcMRI:$MATLABPATH
MATLABPATH=$MNAPPATH/matlab/fcMRI:$MATLABPATH
MATLABPATH=$MNAPPATH/matlab/general:$MATLABPATH
MATLABPATH=$MNAPPATH/matlab/gmri:$MATLABPATH
MATLABPATH=$MNAPPATH/matlab/stats:$MATLABPATH

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
    echo " --add=<absolute_path_for_file_to_add_and_commit>                   Specify file to add with absolute path when 'push' is selected. Default []. "
    echo "                                                                    Note: If 'all' is specified then will run git add on entire repo."
    echo "                                                                    e.g. $TOOLS/$MNAPREPO/connector/mnap.sh "
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
    echo "--add='files_to_add' \ "
    echo "--message='Committing change' "
    echo ""
}

function_gitmnapbranch() {
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
LOCAL=$(git rev-parse origin)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")
echo ""
echo "   ==> Local commit:   $LOCAL"
echo "   ==> Remote commit:  $REMOTE"
# -- Run a few git tests to verify LOCAL, REMOTE and BASE tips
if [[ $LOCAL == $REMOTE ]]; then
    cyaneho "   ==> STATUS OK: LOCAL equals REMOTE in $MNAPDirBranchTest."; echo ""
elif [[ $LOCAL == $BASE ]]; then
    reho "   ==> ACTION NEEDED: LOCAL equals BASE in ${MNAPDirBranchTest}. You need to pull."; echo ""
elif [[ $REMOTE == $BASE ]]; then
    reho "   ==> ACTION NEEDED: REMOTE equals BASE in ${MNAPDirBranchTest}. You need to push."; echo ""
else
    echo ""
    reho "   ===> ERROR: LOCAL, BASE and REMOTE tips have diverged in ${MNAPDirBranchTest}."
    echo ""
    reho "   ------------------------------------------------"
    reho "      LOCAL: ${LOCAL}"
    reho "      BASE: ${BASE}"
    reho "      REMOTE: ${REMOTE}"
    reho "   ------------------------------------------------"
    echo ""
    reho "   ===> Check 'git status -uno' to inspect and re-run after cleaning things up."
    echo ""
fi
}
alias gitmnapbranch=function_gitmnapbranch

function_gitmnapstatus() {
echo ""
geho "================ Running MNAP Suite Repository Status Check ================"
echo ""
unset MNAPBranchPath; unset MNAPSubModules; unset MNAPSubModule
# -- Run it for the main module
cd ${TOOLS}/${MNAPREPO}
echo ""; geho "--- Checking status in MNAP Suite location: ${TOOLS}/${MNAPREPO} "; echo ""
git status -uno; function_gitmnapbranch
# -- Then iterate over submodules
MNAPSubModules=`cd ${TOOLS}/${MNAPREPO}; git submodule status | awk '{ print $2 }' | sed 's/hcpextendedpull//' | sed '/^\s*$/d'`
MNAPBranchPath="${MNAPPATH}"
for MNAPSubModule in ${MNAPSubModules}; do
    cd ${MNAPBranchPath}/${MNAPSubModule}
    function_gitmnapbranch
    git status -uno
done
cd ${TOOLS}/${MNAPREPO}
echo ""
geho "================ Completed MNAP Suite Repository Status Check ================"
echo ""
}
alias gitmnapstatus=function_gitmnapstatus

# -- function_gitmnap start

function_gitmnap() {
unset MNAPSubModules
MNAPSubModules=`cd $MNAPPATH; git submodule status | awk '{ print $2 }' | sed 's/hcpextendedpull//' | sed '/^\s*$/d'`
# -- Inputs
unset MNAPBranch
unset MNAPAddFiles
unset MNAPGitCommand
unset MNAPBranchPath
unset CommitMessage
unset GitStatus
unset MNAPSubModulesList
MNAPGitCommand=`opts_GetOpt "--command" $@`
MNAPAddFiles=`opts_GetOpt "--add" "$@" | sed 's/,/ /g;s/|/ /g'`; MNAPSubModulesList=`echo "$MNAPSubModulesList" | sed 's/,/ /g;s/|/ /g'` # list of input cases; removing comma or pipes
MNAPBranch=`opts_GetOpt "--branch" $@`
MNAPBranchPath=`opts_GetOpt "--branchpath" $@`
CommitMessage=`opts_GetOpt "--message" "${@}"`
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
    if [[ -z ${CommitMessage} ]]; then reho ""; reho "   Error: --message flag missing. Please specify commit message."; echo ""; gitmnap_usage; return 1; else CommitMessage="${CommitMessage}"; fi
    if [[ -z ${MNAPAddFiles} ]]; then reho ""; reho "   Error: --add flag not defined. Run 'gitmnapstatus' and specify which files to add."; echo ""; gitmnap_usage; return 1; fi
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
    function_gitmnapbranch > /dev/null 2>&1
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
            if [[ ${MNAPAddFiles} == "all" ]]; then
                git add ./*
            else
                git add ${MNAPAddFiles}
            fi
            git commit . --message="${CommitMessage}"
            git push origin ${MNAPBranch}
        fi
    fi
    function_gitmnapbranch
    echo ""
    geho "--- Completed MNAP git ${MNAPGitCommand} for ${MNAPBranch} on MNAP main repo in ${MNAPBranchPath}."; echo ""
    return 1
fi

# -- Check if all submodules are requested or only specific ones
if [ ${MNAPSubModulesList} == "all" ]; then
    # -- Reset submodules variable to all
    unset MNAPSubModulesList
    MNAPSubModulesList=`cd $MNAPPATH; git submodule status | awk '{ print $2 }' | sed 's/hcpextendedpull//' | sed '/^\s*$/d'`
    MNAPSubModules=${MNAPSubModulesList}
    if [[ ${MNAPAddFiles} != "all" ]] && [[ ${MNAPGitCommand} == "push" ]]; then
        reho "ERROR: Cannot specify all submodules and select files. Specify specific files for a given submodule or specify -add='all' "
        return 1
        gitmnap_usage
    else
        GitAddCommand="git add ./*"
    fi
elif [ ${MNAPSubModulesList} == "main" ]; then
    echo ""
    geho "Note: --submodules flag set to the main MNAP repo."
    echo ""
    MNAPSubModules="main"
    if [[ ${MNAPAddFiles} == "all" ]] && [[ ${MNAPGitCommand} == "push" ]]; then
        GitAddCommand="git add ./*"
    else
        GitAddCommand="git add ${MNAPAddFiles}"
    fi
elif [[ ${MNAPSubModulesList} != "main*" ]] && [[ ${MNAPSubModulesList} != "all*" ]]; then
    MNAPSubModules=${MNAPSubModulesList}
    echo ""
    geho "Note: --submodules flag set to selected MNAP repos: $MNAPSubModules"
    echo ""
    if [[ ${MNAPAddFiles} != "all" ]] && [[ ${MNAPGitCommand} == "push" ]]; then
        if [[ `echo ${MNAPSubModules} | wc -w` != 1 ]]; then 
            reho "Note: More than one submodule requested"
            reho "ERROR: Cannot specify several submodules and select specific files. Specify specific files for a given submodule or specify -add='all' "
            return 1
        fi 
        GitAddCommand="git add ${MNAPAddFiles}"
    else
        GitAddCommand="git add ./*"
    fi
fi

# -- Continue with specific submodules
echo ""
mageho "  * Checking active branch ${MNAPBranch} for specified submodules in ${MNAPBranchPath}... "
echo ""
for MNAPSubModule in ${MNAPSubModules}; do
    cd ${MNAPBranchPath}/${MNAPSubModule}
    if [[ -z `git branch | grep "${MNAPBranch}"` ]]; then reho "Error: Branch $MNAPBranch does not exist in $MNAPBranchPath/$MNAPSubModule. Check your repo."; echo ""; gitmnap_usage; return 1; else geho "   --> $MNAPBranch found in $MNAPBranchPath/$MNAPSubModule"; echo ""; fi
    if [[ -z `git branch | grep "* ${MNAPBranch}"` ]]; then reho "Error: Branch $MNAPBranch is not checked out and active in $MNAPBranchPath/$MNAPSubModule. Check your repo."; echo ""; gitmnap_usage; return 1; else geho "   --> $MNAPBranch is active in $MNAPBranchPath/$MNAPSubModule"; echo ""; fi
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
    function_gitmnapbranch > /dev/null 2>&1
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
            eval ${GitAddCommand}
            git commit . --message="${CommitMessage}"
            git push origin ${MNAPBranch}
        fi
    fi
    function_gitmnapbranch
    echo ""
    geho "--- Completed MNAP git ${MNAPGitCommand} for ${MNAPBranch} on MNAP submodule ${MNAPBranchPath}/${MNAPSubModule}."; echo ""; echo ""
done
unset MNAPSubModule

# -- Finish up with the main submodule after individual modules are committed
echo ""
geho "--- Running MNAP git ${MNAPGitCommand} for ${MNAPBranch} on MNAP main repo in ${MNAPBranchPath}."
echo
cd ${MNAPBranchPath}
function_gitmnapbranch > /dev/null 2>&1
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
function_gitmnapbranch
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
# -- Module setup if using a cluster
# ------------------------------------------------------------------------------

# # -- Load additional needed modules
# if [[ ${LMODPRESENT} == "yes" ]]; then
#     LoadModules="Libs/netlib Libs/QT/5.6.2 Apps/R Rpkgs/RCURL/1.95 Langs/Python/2.7.14 Tools/GIT/2.6.2 Tools/Mercurial/3.6 GPU/Cuda/7.5 Rpkgs/GGPLOT2 Libs/SCIPY/0.13.3 Libs/PYDICOM/0.9.9 Libs/NIBABEL/2.0.1 Libs/MATPLOTLIB/1.4.3 Libs/AWS/1.11.66 Libs/NetCDF/4.3.3.1-parallel-intel2013 Libs/NUMPY/1.9.2 Langs/Lua/5.3.3"
#     echo ""; cyaneho " ---> LMOD present. Loading Modules..."
#     for LoadModule in ${LoadModules}; do
#         module load ${LoadModule} &> /dev/null
#     done
#     echo ""; cyaneho " ---> Loaded Modules:  ${LoadModules}"; echo ""
# fi

# ------------------------------------------------------------------------------
# -- Setup CUDA
# ------------------------------------------------------------------------------

# -- set binary location depending on CUDA 
if [[ ${LMODPRESENT} != "yes" ]]; then
    PATH=/usr/local/cuda-7.5/bin:$PATH
    LD_LIBRARY_PATH=/usr/local/cuda-7.5/lib64:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH
    BedpostXGPUDir="bedpostx_gpu_cuda_7.5" 
    ProbTrackXDIR="${FSLGPUBinary}/probtrackx_gpu_cuda_7.0"
    bindir=${FSLGPUBinary}/${BedpostXGPUDir}/bedpostx_gpu
    export BedpostXGPUDir; export ProbTrackXDIR; export bindir; PATH=${bindir}:${PATH}; PATH=${bindir}/lib:${PATH}; PATH=${bindir}/bin:${PATH}; PATH=${ProbTrackXDIR}:${PATH}; export PATH
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${bindir}/lib
fi
if [[ ! -z `command -v nvcc` ]]; then
    if [[ `nvcc --version | grep "release"` == *"6.0"* ]]; then NVCCVer="6.0"; fi
    if [[ `nvcc --version | grep "release"` == *"6.5"* ]]; then NVCCVer="6.5"; fi
    if [[ `nvcc --version | grep "release"` == *"7.0"* ]]; then NVCCVer="7.0"; fi
    if [[ `nvcc --version | grep "release"` == *"7.5"* ]]; then NVCCVer="7.5"; fi
    if [[ `nvcc --version | grep "release"` == *"8.0"* ]]; then NVCCVer="8.0"; fi
    BedpostXGPUDir="bedpostx_gpu_cuda_${NVCCVer}" 
    ProbTrackXDIR="${FSLGPUBinary}/probtrackx_gpu_cuda_${NVCCVer}"
    bindir=${FSLGPUBinary}/${BedpostXGPUDir}/bedpostx_gpu
    export BedpostXGPUDir; export ProbTrackXDIR; export bindir; PATH=${bindir}:${PATH}; PATH=${bindir}/lib:${PATH}; PATH=${bindir}/bin:${PATH}; PATH=${ProbTrackXDIR}:${PATH}; export PATH
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${bindir}/lib
    #module load GPU/Cuda/${NVCCVer} &> /dev/null # Module setup if using a cluster
fi

MNAPEnvCheck=`source ${TOOLS}/${MNAPREPO}/library/environment/mnap_envStatus.sh --envstatus | grep "ERROR"` > /dev/null 2>&1
if [[ -z ${MNAPEnvCheck} ]]; then
    geho " ---> MNAP environment set successfully!"
    echo ""
else
    reho "   --> ERROR in MNAP environment. Run 'mnap_envstatus' to check missing variables!"
    echo ""
fi
