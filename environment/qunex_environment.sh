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
#  qunex_environment.sh
#
# ## LICENSE
#
# * The qunex_environment.sh = the "Software"
# * This Software conforms to the license outlined in the Qu|Nex Suite:
# * https://bitbucket.org/oriadev/qunex/src/master/LICENSE.md
#
# ## TODO
#
#
# ## DESCRIPTION:
#
# * This is a general script developed as a front-end environment and path organization for the Qu|Nex infrastructure
#
# ## PREREQUISITE INSTALLED SOFTWARE
#
# * Qu|Nex Suite
#
# ## PREREQUISITE ENVIRONMENT VARIABLES
#
# * This script needs to be sourced in each users .bash_profile like so:
#
#    TOOLS=/<absolute_path_to_software_folder>
#    export TOOLS
#    source $TOOLS/library/environment/qunex_environment.sh
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
    echo "This script implements the global environment setup for the Qu|Nex Suite."
    echo ""
    echo ""
    echo "    Configure the environment script by adding the following lines to the .bash_profile "
    echo ""
    echo "    -->TOOLS=<path_to_folder_with_qunex_software> "
    echo "    -->export TOOLS "
    echo "    -->source <path_to_folder_with_qunex_software>/library/environment/qunex_environment.sh "
    echo ""
    echo "    Permissions of this file need to be set to 770 "
    echo ""
    echo "-- REQUIRED DEPENDENCIES:"
    echo ""
    echo " The Qu|Nex Suite assumes a set default folder names for dependencies if undefined by user environment."
    echo " These are defined relative to the ${TOOLS} folder which should be set as a global system variable."
    echo ""
    echo "  TOOLS                              --> The base folder for the dependency installation "
    echo "  │ "
    echo "  ├── qunex                          --> Env. Variable => QUNEXREPO -- All Qu|Nex Suite repositories (https://bitbucket.org/hidradev/qunextools) "
    echo "  │ "
    echo "  ├── env                             --> conda environments with python packages"
    echo "  │   └── qunex                        --> Env. Variable => QUNEXENV (python2.7 versions of the required packages)"
    echo "  │ "
    echo "  ├── HCP                             --> Human Connectome Tools Folder "
    echo "  │   ├── Pipelines                   --> Human Connectome Pipelines Folder (https://github.com/Washington-University/HCPpipelines) | Env. Variable => HCPPIPEDIR "
    echo "  │   ├── Pipelines-<VERSION>         --> Point any other desired version point to HCPPIPEDIR "
    echo "  │   └── RunUtils                    --> Env. Variable => HCPPIPERUNUTILS "
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
    echo "  ├── miniconda                       --> miniconda2 for python environment management and package installation (https://conda.io/projects/conda/en/latest/user-guide/install/) "
    echo "  │   └── miniconda-latest            --> Env. Variable => CONDADIR "
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
    echo "  ├── pylib                           --> Env. Variable => PYLIBDIR      -- All Qu|Nex python libraries and tools "
    echo "  ├── gradunwarp                      --> HCP version of gradunwarp (https://github.com/Washington-University/gradunwarp) "
    echo "  │   └── gradunwarp-latest           --> Env. Variable => GRADUNWARPDIR"
    echo "  │ "
    echo "  └── workbench/workbench-<VERSION>   Connectome Workbench (v1.0 or above; https://www.humanconnectome.org/software/connectome-workbench) "
    echo "      └── workbench-<VERSION>         Env. Variable = HCPWBDIR "
    echo ""
    echo " These defaults can be redefined if the above paths are declared as global variables in the .bash_profile profile after loading the Qu|Nex environment."
    echo ""
    geho "  ==> For full environment report run 'qunex environment'"
    echo ""
    exit 0
}

if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "?help" ] || [ "$1" == "--usage" ] || [ "$1" == "-usage" ] || [ "$1" == "usage" ] || [ "$1" == "?usage" ]; then
    usage
fi

# ------------------------------------------------------------------------------
#  Environment clear and check functions
# ------------------------------------------------------------------------------

ENVVARIABLES='PATH MATLABPATH PYTHONPATH QUNEXVer TOOLS QUNEXREPO QUNEXPATH TemplateFolder FSL_FIXDIR POSTFIXICADIR FREESURFERDIR FREESURFER_HOME FREESURFER_SCHEDULER FreeSurferSchedulerDIR WORKBENCHDIR DCMNIIDIR DICMNIIDIR MATLABDIR MATLABBINDIR OCTAVEDIR OCTAVEPKGDIR OCTAVEBINDIR RDIR HCPWBDIR AFNIDIR PYLIBDIR FSLDIR FSLGPUDIR PALMDIR QUNEXMCOMMAND HCPPIPEDIR CARET7DIR GRADUNWARPDIR HCPPIPEDIR_Templates HCPPIPEDIR_Bin HCPPIPEDIR_Config HCPPIPEDIR_PreFS HCPPIPEDIR_FS HCPPIPEDIR_PostFS HCPPIPEDIR_fMRISurf HCPPIPEDIR_fMRIVol HCPPIPEDIR_tfMRI HCPPIPEDIR_dMRI HCPPIPEDIR_dMRITract HCPPIPEDIR_Global HCPPIPEDIR_tfMRIAnalysis MSMBin HCPPIPEDIR_dMRITracFull HCPPIPEDIR_dMRILegacy AutoPtxFolder FSLGPUBinary EDDYCUDADIR USEOCTAVE QUNEXENV CONDADIR MSMBINDIR MSMCONFIGDIR'
export ENVVARIABLES

# -- Check if inside the container and reset the environment on first setup
if [[ -e /opt/.container ]]; then
    # -- Perform initial reset for the environment in the container
    if [[ "$FIRSTRUNDONE" != "TRUE" ]]; then

        # -- First unset all conflicting variables in the environment
        echo "--> unsetting all environment variables: $ENVVARIABLES"
        unset $ENVVARIABLES

        # -- Set PATH
        export PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

        # -- Check for specific settings a user might want:

        # --- This is a file that should reside in a user's home folder and it should contain the settings the user wants to make that are different from the defaults.
        if [ -f ~/.qunex_container.rc ]; then
            echo "--> sourcing  ~/.qunex_container.rc"
            . ~/.qunex_container.rc
        fi

        # --- This is an environmental variable that if set should hold a path to a bash script that contains the settings the user wants to make that are different from the defaults.
        if [[ ! -z "$QUNEXCONTAINERENV" ]]; then    
            echo "--> QUNEXCONTAINERENV set: sourcing $QUNEXCONTAINERENV"
            . $QUNEXCONTAINERENV
        fi

        # --- Check for presence of set con_<VariableName>. If present <VariableName> is set to con_<VariableName>

        for ENVVAR in $ENVVARIABLES
        do
            if [[ ! -z $(eval echo "\${con_$ENVVAR+x}") ]]; then
                echo "--> setting $ENVVAR to value of con_$ENVVAR [$(eval echo \"\$con_$ENVVAR\")]"
                export $ENVVAR="$(eval echo \"\$con_$ENVVAR\")"
            fi
        done

        if [ -z ${TOOLS+x} ]; then TOOLS="/opt"; fi
        if [ -z ${USEOCTAVE+x} ]; then USEOCTAVE="TRUE"; fi

        PATH=${TOOLS}:${PATH}
        export TOOLS PATH USEOCTAVE
        export FIRSTRUNDONE="TRUE"
    fi

elif [[ -e ~/.qunexuseoctave ]]; then
    export USEOCTAVE="TRUE"
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
export OperatingSystem OSInfo

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

PS1="\[\e[0;36m\][Qu|Nex \W]\$\[\e[0m\] "
PROMPT_COMMAND='echo -ne "\033]0;Qu|Nex: ${PWD}\007"'

# ------------------------------------------------------------------------------
# -- Qu|Nex - General Code
# ------------------------------------------------------------------------------

if [ -z ${QUNEXREPO} ]; then
    QUNEXREPO="qunex"
fi

# ---- changed to work with new clone/branches setup

if [ -e ~/qunexinit.sh ]; then
    source ~/qunexinit.sh
fi

QUNEXPATH=${TOOLS}/${QUNEXREPO}
QuNexVer=`cat ${TOOLS}/${QUNEXREPO}/VERSION.md`
export QUNEXPATH QUNEXREPO QuNexVer

if [ -e ~/qunexinit.sh ]; then
    echo ""
    reho " --- NOTE: Qu|Nex is set by your ~/qunexinit.sh file! ----"
    echo ""
    reho " ---> Qu|Nex path is set to: ${QUNEXPATH} "
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
if [[ -z ${FREESURFERDIR} ]]; then FREESURFERDIR="${TOOLS}/freesurfer/freesurfer-6.0"; export FREESURFERDIR; fi
if [[ -z ${FreeSurferSchedulerDIR} ]]; then FreeSurferSchedulerDIR="${TOOLS}/freesurfer/FreeSurferScheduler"; export FreeSurferSchedulerDIR; fi
if [[ -z ${HCPWBDIR} ]]; then HCPWBDIR="${TOOLS}/workbench/workbench-latest"; export HCPWBDIR; fi
if [[ -z ${AFNIDIR} ]]; then AFNIDIR="${TOOLS}/afni/afni-latest"; export AFNIDIR; fi
if [[ -z ${DCMNIIDIR} ]]; then DCMNIIDIR="${TOOLS}/dcm2niix/dcm2niix-latest"; export DCMNIIDIR; fi
if [[ -z ${DICMNIIDIR} ]]; then DICMNIIDIR="${TOOLS}/dicm2nii/dicm2nii-latest"; export DICMNIIDIR; fi
if [[ -z ${OCTAVEDIR} ]]; then OCTAVEDIR="${TOOLS}/octave/octave-latest"; export OCTAVEDIR; fi
if [[ -z ${OCTAVEPKGDIR} ]]; then OCTAVEPKGDIR="${TOOLS}/octave/octavepkg"; export OCTAVEPKGDIR; fi
if [[ -z ${PYLIBDIR} ]]; then PYLIBDIR="${TOOLS}/pylib"; export PYLIBDIR; fi
if [[ -z ${FMRIPREPDIR} ]]; then FMRIPREPDIR="${TOOLS}/fmriprep/fmriprep-latest"; export FMRIPREPDIR; fi
if [[ -z ${MATLABDIR} ]]; then MATLABDIR="${TOOLS}/matlab/matlab-latest"; export MATLABDIR; fi
if [[ -z ${GRADUNWARPDIR} ]]; then GRADUNWARPDIR="${TOOLS}/gradunwarp/gradunwarp-latest"; export GRADUNWARPDIR; fi
if [[ -z ${QUNEXENV} ]]; then QUNEXENV="${TOOLS}/env/qunex"; export QUNEXENV; fi
if [[ -z ${CONDADIR} ]]; then CONDADIR="${TOOLS}/miniconda/miniconda-latest"; export CONDADIR; fi
if [[ -z ${RDIR} ]]; then RDIR="${TOOLS}/R/R-latest"; export RDIR; fi
if [[ -z ${USEOCTAVE} ]]; then USEOCTAVE="FALSE"; export USEOCTAVE; fi
if [[ -z ${MSMBINDIR} ]]; then MSMBINDIR="$TOOLS/HCP/MSM_HOCR_v1/Centos"; export MSMBINDIR; fi
if [[ -z ${MSMCONFIGDIR} ]]; then MSMCONFIGDIR=${HCPPIPEDIR}/MSMConfig; export MSMCONFIGDIR; fi
if [[ -z ${MATLAB_COMPILER_RUNTIME} ]]; then MATLAB_COMPILER_RUNTIME=${MATLABDIR}/runtime; export MATLAB_COMPILER_RUNTIME; fi

# -- The commented line will be the default once HCP Team accepts the pull request
#if [[ -z ${HCPPIPEDIR} ]]; then HCPPIPEDIR="${TOOLS}/HCP/Pipelines"; export HCPPIPEDIR; fi
# -- The line below points to the environment expectation if using the 'dev' extended version of HCP Pipelines directly from QuNex repo
if [[ -z ${HCPPIPEDIR} ]]; then HCPPIPEDIR="${TOOLS}/qunex/hcp"; export HCPPIPEDIR; fi


# -- conda management
CONDABIN=${CONDADIR}/bin
PATH=${CONDABIN}:${PATH}
export CONDABIN PATH
source deactivate 2> /dev/null

# Activate conda environment
source activate $QUNEXENV 2> /dev/null


# -- Checks for version
showVersion() {
    QuNexVer=`cat ${TOOLS}/${QUNEXREPO}/VERSION.md`
    echo ""
    geho " Loading Quantitative Neuroimaging Environment & ToolboX (Qu|Nex) Version: v${QuNexVer}"
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
geho ""
geho "        ██████\                  ║      ██\   ██\                    "
geho "       ██  __██\                 ║      ███\  ██ |                   "
geho "       ██ /  ██ |██\   ██\       ║      ████\ ██ | ██████\ ██\   ██\ "
geho "       ██ |  ██ |██ |  ██ |      ║      ██ ██\██ |██  __██\\\\\██\ ██  |"
geho "       ██ |  ██ |██ |  ██ |      ║      ██ \████ |████████ |\████  / "
geho "       ██ ██\██ |██ |  ██ |      ║      ██ |\███ |██   ____|██  ██<  "
geho "       \██████ / \██████  |      ║      ██ | \██ |\███████\██  /\██\ "
geho "        \___███\  \______/       ║      \__|  \__| \_______\__/  \__|"
geho "            \___|                ║                                   "
geho ""
geho "                       DEVELOPED & MAINTAINED BY: "
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
geho " a part of the Qu|Nex Suite source code package:"
geho "    https://bitbucket.org/hidradev/qunextools/src/master/LICENSE.md"
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
#     if [ -f ~/.qunexuseoctave ] && [[ ${LMODOCTAVE} == "yes" ]]; then
#         module load Libs/netlib &> /dev/null
#         module load Apps/Octave/4.2.1 &> /dev/null
#         echo ""; cyaneho " ---> Selected to use Octave instead of Matlab! "
#         OctaveTest="pass"
#     fi
#     if [ -f ~/.qunexuseoctave ] && [[ ${LMODOCTAVE} == "no" ]]; then
#         echo ""; reho " ===> ERROR: .qunexuseoctave set but no Octave module is present on the system."; echo ""
#         OctaveTest="fail"
#     fi
#     if [ ! -f ~/.qunexuseoctave ] && [[ ${LMODMATLAB} == "yes" ]]; then
#         module load Apps/Matlab/R2018a &> /dev/null
#         echo ""; cyaneho " ---> Selected to use Matlab!"
#         MatlabTest="pass"
#     fi
#     if [ ! -f ~/.qunexuseoctave ] && [[ ${LMODMATLAB} == "no" ]]; then
#         echo ""; reho " ===> ERROR: Matlab selected and Lmod found but Matlab module missing. Alert your SysAdmin"; echo ""
#         MatlabTest="fail"
#     fi
# fi

# ------------------------------------------------------------------------------
# -- Running matlab vs. octave
# ------------------------------------------------------------------------------

if [ "$USEOCTAVE" == "TRUE" ]; then
    if [[ ${OctaveTest} == "fail" ]]; then 
        reho " ===> ERROR: Cannot setup Octave because module test failed."
    else
         ln -s `which octave` ${OCTAVEDIR}/octave > /dev/null 2>&1
         export OCTAVEPKGDIR
         export OCTAVEDIR
         export OCTAVEBINDIR
         cyaneho " ---> Setting up Octave "; echo ""
         QUNEXMCOMMAND='octave -q --no-init-file --eval'
         if [ ! -e ~/.octaverc ]; then
             cp ${QUNEXPATH}/library/.octaverc ~/.octaverc
         fi
         export LD_LIBRARY_PATH=/usr/lib64/hdf5/:LD_LIBRARY_PATH > /dev/null 2>&1
         if [[ -z ${PALMDIR} ]]; then PALMDIR="${TOOLS}/palm/palm-latest-o"; fi
    fi
else
    # if [[ ${MatlabTest} == "fail" ]]; then
    #     reho " ===> ERROR: Cannot setup Matlab because module test failed."
    # else
         
         cyaneho " ---> Setting up Matlab "; echo ""
         QUNEXMCOMMAND='matlab -nodisplay -nosplash -r'
         if [[ -z ${PALMDIR} ]]; then PALMDIR="${TOOLS}/palm/palm-latest-m"; fi
    # fi
fi
# -- Use the following command to run .m code in Matlab
export QUNEXMCOMMAND

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
unset FSL_DIR
FREESURFER_HOME=${FREESURFERDIR}
PATH=${FREESURFER_HOME}:${PATH}
export FREESURFER_HOME PATH
. ${FREESURFER_HOME}/SetUpFreeSurfer.sh > /dev/null 2>&1

# -- FSL path
# -- Note: Always run after FreeSurfer for correct environment specification
#          because SetUpFreeSurfer.sh can mis-specify the $FSLDIR path

PATH=${FSLDIR}/bin:${PATH}
source ${FSLDIR}/etc/fslconf/fsl.sh > /dev/null 2>&1
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
# -- Setup overall Qu|Nex paths
# ------------------------------------------------------------------------------

QUNEXCONNPATH=$QUNEXPATH/connector
PATH=${QUNEXCONNPATH}:${PATH}
export QUNEXCONNPATH PATH
PATH=$QUNEXPATH/connector/functions:$PATH
export QUNEXFUNCTIONS=${QUNEXCONNPATH}/functions
MATLABPATH=$QUNEXPATH/connector:$MATLABPATH
export MATLABPATH

HCPATLAS=$QUNEXPATH/library/data/atlases/HCP
PATH=${HCPATLAS}:${PATH}
export HCPATLAS PATH
MATLABPATH=$HCPATLAS:$MATLABPATH
export MATLABPATH

TemplateFolder=$QUNEXPATH/library/data/
PATH=${TemplateFolder}:${PATH}
export TemplateFolder PATH
MATLABPATH=$TemplateFolder:$MATLABPATH
export MATLABPATH

# -- Define submodules, but omit hcpextendedpull to avoid conflicts
unset QuNexSubModules
QuNexSubModules=`cd $QUNEXPATH; git submodule status | awk '{ print $2 }' | sed 's/hcpextendedpull//' | sed '/^\s*$/d'`

#alias qunex='bash ${TOOLS}/${QUNEXREPO}/connector/qunex.sh'
alias qunex_envset='source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_environment.sh'
alias qunex_environment_set='source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_environment.sh'

alias qunex_envhelp='bash ${TOOLS}/${QUNEXREPO}/library/environment/qunex_environment.sh --help'
alias qunex_environment_help='bash ${TOOLS}/${QUNEXREPO}/library/environment/qunex_environment.sh --help'

alias qunex_envcheck='source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_envStatus.sh --envstatus'
alias qunex_envstatus='source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_envStatus.sh --envstatus'
alias qunex_envreport='source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_envStatus.sh --envstatus'
alias qunex_environment_check='source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_envStatus.sh --envstatus'
alias qunex_environment_status='source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_envStatus.sh --envstatus'
alias qunex_environment_report='source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_envStatus.sh --envstatus'

alias qunex_envreset='source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_envStatus.sh --envclear'
alias qunex_envclear='source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_envStatus.sh --envclear'
alias qunex_envpurge='source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_envStatus.sh --envclear'
alias qunex_environment_reset='source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_envStatus.sh --envclear'
alias qunex_environment_clear='source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_envStatus.sh --envclear'
alias qunex_environment_purge='source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_envStatus.sh --envclear'

# ------------------------------------------------------------------------------
# -- Setup HCP Pipeline paths
# ------------------------------------------------------------------------------

# -- Re-Set HCP Pipeline path to different version if needed 
if [ -e ~/.qunexhcpe ];
    then
    export HCPPIPEDIR=${TOOLS}/${QUNEXREPO}/hcp
    echo ""
    reho " ===> NOTE: You are in Qu|Nex HCP development mode!"
    reho " ---> Qu|Nex HCP path is set to: $HCPPIPEDIR"
    echo ""
fi

# -- Export HCP Pipeline and relevant variables
export PATH=${HCPPIPEDIR}:${MSMCONFIGDIR}:${PATH}; export PATH
export CARET7DIR=$WORKBENCHDIR; PATH=${CARET7DIR}:${PATH}; export PATH
export GRADUNWARPBIN=$GRADUNWARPDIR/gradunwarp/core; PATH=${GRADUNWARPBIN}:${PATH}; export PATH
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
export HCPPIPEDIR_Global=${HCPPIPEDIR}/global/scripts; PATH=${HCPPIPEDIR_Global}:${PATH}; export PATH
export HCPPIPEDIR_tfMRIAnalysis=${HCPPIPEDIR}/TaskfMRIAnalysis/scripts; PATH=${HCPPIPEDIR_tfMRIAnalysis}:${PATH}; export PATH
export MSMBin=${HCPPIPEDIR}/MSMBinaries; PATH=${MSMBin}:${PATH}; export PATH
export HCPPIPEDIR_dMRITract=${TOOLS}/${QUNEXREPO}/connector/functions/DiffusionTractography/scripts; PATH=${HCPPIPEDIR_dMRITract}:${PATH}; export PATH
export HCPPIPEDIR_dMRITracFull=${TOOLS}/${QUNEXREPO}/connector/functions/DiffusionTractographyDense; PATH=${HCPPIPEDIR_dMRITracFull}:${PATH}; export PATH
export HCPPIPEDIR_dMRILegacy=${TOOLS}/${QUNEXREPO}/connector/functions; PATH=${HCPPIPEDIR_dMRILegacy}:${PATH}; export PATH
export AutoPtxFolder=${HCPPIPEDIR_dMRITracFull}/autoPtx_HCP_extended; PATH=${AutoPtxFolder}:${PATH}; export PATH
export FSLGPUBinary=${HCPPIPEDIR_dMRITracFull}/fsl_gpu_binaries; PATH=${FSLGPUBinary}:${PATH}; export PATH
export EDDYCUDADIR=${FSLGPUBinary}/eddy_cuda; PATH=${EDDYCUDADIR}:${PATH}; export PATH; eddy_cuda="eddy_cuda_wQC"; export eddy_cuda


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
FIXDIR_DEPEND=${QUNEXPATH}/library/etc/ICAFIXDependencies
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
POSTFIXICADIR=${TOOLS}/${QUNEXREPO}/hcpmodified/PostFix
PATH=${POSTFIXICADIR}:${PATH}
export POSTFIXICADIR PATH
MATLABPATH=$POSTFIXICADIR:$MATLABPATH
export MATLABPATH

# ------------------------------------------------------------------------------
# -- Qu|Nex - NIUtilities and Matlab Paths
# ------------------------------------------------------------------------------

# -- Make sure gmri is executable
chmod ugo+x $QUNEXPATH/niutilities/gmri &> /dev/null

# -- Setup additional paths
PATH=$QUNEXPATH/connector:$PATH
PATH=$QUNEXPATH/niutilities:$PATH
PATH=$QUNEXPATH/library/bin:$PATH
PATH=$QUNEXPATH/nitools:$PATH
PATH=$TOOLS/bin:$PATH
# PATH=$PYLIBDIR/gradunwarp:$PATH
# PATH=$PYLIBDIR/gradunwarp/core:$PATH
# PATH=$PYLIBDIR/xmlutils.py:$PATH
# PATH=$PYLIBDIR:$PATH
# PATH=$PYLIBDIR/bin:$PATH
# PATH=$TOOLS/MeshNet:$PATH
PATH=/usr/local/bin:$PATH
PATH=$PATH:/bin
PATH=$TOOLS/olib:$PATH
PATH=$TOOLS/bin:$PATH


# --- setup PYTHONPATH and PATH When not conda

#if [ ! -e /opt/.hcppipelines ]; then 
#    PYTHONPATH=$TOOLS:$PYTHONPATH
#    PYTHONPATH=$TOOLS/pylib:$PYTHONPATH
#    PYTHONPATH=/usr/local/bin:$PYTHONPATH
#    PYTHONPATH=$TOOLS/env/qunex/bin:$PYTHONPATH
#    PYTHONPATH=$TOOLS/miniconda/miniconda-latest/pkgs:$PYTHONPATH
#    PYTHONPATH=$TOOLS/env/qunex/lib/python2.7/site-packages:$PYTHONPATH
#    PYTHONPATH=$TOOLS/env/qunex/lib/python2.7/site-packages/nibabel/xmlutils.py:$PYTHONPATH
#    PYTHONPATH=$TOOLS/env/qunex/lib/python2.7/site-packages/pydicom:$PYTHONPATH
#    PYTHONPATH=$TOOLS/env/qunex/lib/python2.7/site-packages/gradunwarp:$PYTHONPATH
#    PYTHONPATH=$TOOLS/env/qunex/lib/python2.7/site-packages/gradunwarp/core:$PYTHONPATH
#    PYTHONPATH=$QUNEXPATH:$PYTHONPATH
#    PYTHONPATH=$QUNEXPATH/connector:$PYTHONPATH
#    PYTHONPATH=$QUNEXPATH/niutilities:$PYTHONPATH
#    PYTHONPATH=$QUNEXPATH/matlab:$PYTHONPATH
#    PYTHONPATH=$PYLIBDIR/bin:$PYTHONPATH
#    PYTHONPATH=$PYLIBDIR/lib/python2.7/site-packages:$PYTHONPATH
#    PYTHONPATH=$PYLIBDIR/lib64/python2.7/site-packages:$PYTHONPATH
#    PYTHONPATH=$PYLIBDIR:$PYTHONPATH
#    PATH=$TOOLS/env/qunex/bin:$PATH
#fi

#export PATH
#export PYTHONPATH


# -- Export Python paths (before change to conda)
# PYTHONPATH=$TOOLS:$PYTHONPATH
# PYTHONPATH=$TOOLS/pylib:$PYTHONPATH
# PYTHONPATH=/usr/local/bin:$PYTHONPATH
# PYTHONPATH=/usr/local/bin/python2.7:$PYTHONPATH
# PYTHONPATH=/usr/lib/python2.7/site-packages:$PYTHONPATH
# PYTHONPATH=/usr/lib64/python2.7/site-packages:$PYTHONPATH
# PYTHONPATH=$QUNEXPATH:$PYTHONPATH
# PYTHONPATH=$QUNEXPATH/connector:$PYTHONPATH
# PYTHONPATH=$QUNEXPATH/niutilities:$PYTHONPATH
# PYTHONPATH=$QUNEXPA$TH/matlab:$PYTHONPATH
# PYTHONPATH=$PYLIBDIR/pydicom:$PYTHONPATH
# PYTHONPATH=$PYLIBDIR/gradunwarp:$PYTHONPATH
# PYTHONPATH=$PYLIBDIR/gradunwarp/core:$PYTHONPATH
# PYTHONPATH=$PYLIBDIR/xmlutils.py:$PYTHONPATH
# PYTHONPATH=$PYLIBDIR/bin:$PYTHONPATH
# PYTHONPATH=$PYLIBDIR/lib/python2.7/site-packages:$PYTHONPATH
# PYTHONPATH=$PYLIBDIR/lib64/python2.7/site-packages:$PYTHONPATH
# PYTHONPATH=$PYLIBDIR:$PYTHONPATH
# PYTHONPATH=$TOOLS/MeshNet:$PYTHONPATH
# export PATH
# export PYTHONPATH

# -- Set and export Matlab paths
MATLABPATH=$QUNEXPATH/nitools/fcMRI:$MATLABPATH
MATLABPATH=$QUNEXPATH/nitools/fcMRI:$MATLABPATH
MATLABPATH=$QUNEXPATH/nitools/general:$MATLABPATH
MATLABPATH=$QUNEXPATH/nitools/gmri:$MATLABPATH
MATLABPATH=$QUNEXPATH/nitools/stats:$MATLABPATH

# ------------------------------------------------------------------------------
# -- Path to additional dependencies
# ------------------------------------------------------------------------------

# -- Define additional paths here as needed

# ------------------------------------------------------------------------------
#  Qu|Nex Functions and git aliases for BitBucket commit and pull requests
# ------------------------------------------------------------------------------

# -- gitqunex_usage function help

gitqunex_usage() {
    echo ""
    echo " -- DESCRIPTION for gitqunex function:"
    echo ""
    echo "The Qu|Nex Suite provides functionality for users with repo privileges to easily pull or commit & push changes via git."
    echo "This is done via two aliases that are setup as general environment variables: "
    echo ""
    echo "    * gitqunex   --> Alias for the Qu|Nex function that updates the Qu|Nex Suite via git from the remote repo or pushes changes to remote repo."
    echo ""
    echo ""
    echo " --command=<git_command>                                            Specify git command: push or pull."
    echo " --add=<absolute_path_for_file_to_add_and_commit>                   Specify file to add with absolute path when 'push' is selected. Default []. "
    echo "                                                                    Note: If 'all' is specified then will run git add on entire repo."
    echo "                                                                    e.g. $TOOLS/$QUNEXREPO/connector/qunex.sh "
    echo " --branch=<branch_to_work_on>                                       Specify the branch name you want to pull or commit."
    echo " --branchpath=<absolute_path_to_folder_containing_qunex_suite>       This folder has to have the selected branch checked out."
    echo " --message=<commit_message>                                         Specify commit message if running commitqunex"
    echo " --submodules=<list_of_submodules>                                  Comma, space or pipe separated list of submodules to work on."
    echo "                                                                    'all'      --->  Update both the main repo and all submodules"
    echo "                                                                    'main'     --->  Update only the main repo"
    geho "Qu|Nex Submodules:"
    echo ""
    geho "${QuNexSubModules}"
    echo ""
    echo ""
    echo " -- EXAMPLES:"
    echo ""
    echo "gitqunex \ "
    echo "--command='pull' \ "
    echo "--branch='master' \ "
    echo "--branchpath='$TOOLS/$QUNEXREPO' \ "
    echo "--submodules='all' "
    echo ""
    echo ""
    echo "gitqunex \ "
    echo "--command='push' \ "
    echo "--branch='master' \ "
    echo "--branchpath='$TOOLS/$QUNEXREPO' \ "
    echo "--submodules='all' \ "
    echo "--add='files_to_add' \ "
    echo "--message='Committing change' "
    echo ""
}

function_gitqunexbranch() {
    # -- Check path
    if [[ -z ${QuNexBranchPath} ]]; then
        cd $TOOLS/$QUNEXREPO
    else
        cd ${QuNexBranchPath}
    fi
    if [[ ! -z ${QuNexSubModule} ]]; then
        cd ${QuNexBranchPath}/${QuNexSubModule}
    fi
    # -- Update remote
    git remote update > /dev/null 2>&1
    QuNexDirBranchTest=`pwd`
    QuNexDirBranchCurrent=`git branch | grep '*'`
    echo ""
    geho "==> Running git status checks in ${QuNexDirBranchTest}"
    geho "    Active branch: ${QuNexDirBranchCurrent}"
    # -- Set git variables
    unset UPSTREAM; unset LOCAL; unset REMOTE; unset BASE
    UPSTREAM=${1:-'@{u}'}
    LOCAL=$(git rev-parse origin)
    REMOTE=$(git rev-parse "$UPSTREAM")
    BASE=$(git merge-base "$LOCAL" "$UPSTREAM")
    echo ""
    geho "    -------------------------------------------------------------------------"
    geho "    --> Local commit:                $LOCAL"
    geho "    --> Remote commit:               $REMOTE"
    geho "    --> Base common ancestor commit: $REMOTE"
    echo ""
    
    # -- Run a few git tests to verify LOCAL, REMOTE and BASE tips
    if [[ $LOCAL == $REMOTE ]]; then
        cyaneho "    ==> STATUS OK: LOCAL equals REMOTE in $QuNexDirBranchTest"; echo ""
    elif [[ $LOCAL == $BASE ]]; then
        reho "    ==> ACTION NEEDED: LOCAL equals BASE in ${QuNexDirBranchTest} --> You need to pull."; echo ""
    elif [[ $REMOTE == $BASE ]]; then
        reho "    ==> ACTION NEEDED: REMOTE equals BASE in ${QuNexDirBranchTest} --> You need to push."; echo ""
    else
        reho "    ==> ERROR: LOCAL, BASE and REMOTE tips have diverged in ${QuNexDirBranchTest}"
        echo ""
        reho "    ------------------------------------------------"
        reho "      LOCAL: ${LOCAL}"
        reho "      BASE: ${BASE}"
        reho "      REMOTE: ${REMOTE}"
        reho "    ------------------------------------------------"
        echo ""
        reho "    ==> Check 'git status -uno' to inspect and re-run after cleaning things up."
        echo ""
    fi
}
alias gitqunexbranch=function_gitqunexbranch

function_gitqunexstatus() {
    
    # -- Function for reporting git status
    function_gitstatusreport() { 
                        #GitStatusReport="$(git status -uno --porcelain | sed 's/M/Modified:/')"
                        GitStatusReport="$(git status --porcelain | sed 's/^/    /' | sed 's/M/Modified:/' | sed 's/??/ Untracked:/')"
                        #GitStatusReport="$(echo ${GitStatusReport} | sed 's/M/-> Modified:/' | sed 's/^/    /')"
                        #GitStatusReport="$(echo ${GitStatusReport} | sed 's/??/\n    -> Untracked:/')"
                        if [[ ! -z ${GitStatusReport} ]]; then
                            reho "${GitStatusReport}"
                        fi
                        geho "    -------------------------------------------------------------------------"
                        echo ""; echo ""
    }

    echo ""
    geho " ================ Running Qu|Nex Suite Repository Status Check ================"
    geho ""
    unset QuNexBranchPath; unset QuNexSubModules; unset QuNexSubModule
    
    # -- Run it for the main module
    cd ${TOOLS}/${QUNEXREPO}
    geho "          Qu|Nex Suite location: ${TOOLS}/${QUNEXREPO}"
    geho " ============================================================================"
    echo ""
    function_gitqunexbranch
    function_gitstatusreport
    
    # -- Then iterate over submodules
    QuNexSubModules=`cd ${TOOLS}/${QUNEXREPO}; git submodule status | awk '{ print $2 }' | sed 's/hcpextendedpull//' | sed '/^\s*$/d'`
    QuNexBranchPath="${QUNEXPATH}"
    for QuNexSubModule in ${QuNexSubModules}; do
        cd ${QuNexBranchPath}/${QuNexSubModule}
        function_gitqunexbranch
        function_gitstatusreport
    done
    cd ${TOOLS}/${QuNexREPO}
    echo ""
    geho " ================ Completed Qu|Nex Suite Repository Status Check ================"
    echo ""
}
alias gitqunexstatus=function_gitqunexstatus

# -- function_gitqunex start

function_gitqunex() {
    unset QuNexSubModules
    QuNexSubModules=`cd $QUNEXPATH; git submodule status | awk '{ print $2 }' | sed 's/hcpextendedpull//' | sed '/^\s*$/d'`
    # -- Inputs
    unset QuNexBranch
    unset QuNexAddFiles
    unset QuNexGitCommand
    unset QuNexBranchPath
    unset CommitMessage
    unset GitStatus
    unset QuNexSubModulesList
    QuNexGitCommand=`opts_GetOpt "--command" $@`
    QuNexAddFiles=`opts_GetOpt "--add" "$@" | sed 's/,/ /g;s/|/ /g'`; QuNexSubModulesList=`echo "$QuNexSubModulesList" | sed 's/,/ /g;s/|/ /g'` # list of input cases; removing comma or pipes
    QuNexBranch=`opts_GetOpt "--branch" $@`
    QuNexBranchPath=`opts_GetOpt "--branchpath" $@`
    CommitMessage=`opts_GetOpt "--message" "${@}"`
    QuNexSubModulesList=`opts_GetOpt "--submodules" "$@" | sed 's/,/ /g;s/|/ /g'`; QuNexSubModulesList=`echo "$QuNexSubModulesList" | sed 's/,/ /g;s/|/ /g'` # list of input cases; removing comma or pipes

    # -- Check for help calls
    if [[ ${1} == "help" ]] || [[ ${1} == "-help" ]] || [[ ${1} == "--help" ]] || [[ ${1} == "?help" ]] || [[ -z ${1} ]]; then
        gitqunex_usage
        return 0
    fi
    if [[ ${1} == "usage" ]] || [[ ${1} == "-usage" ]] || [[ ${1} == "--usage" ]] || [[ ${1} == "?usage" ]] || [[ -z ${1} ]]; then
        gitqunex_usage
        return 0
    fi

    # -- Start execution
    echo ""
    geho "=============== Executing Qu|Nex $QuNexGitCommand function ============== "
    # -- Performing flag checks
    echo ""
    geho "--- Checking inputs ... "
    echo ""
    if [[ -z ${QuNexGitCommand} ]]; then reho ""; reho "   Error: --command flag not defined. Specify 'pull' or 'push' option."; echo ""; gitqunex_usage; return 1; fi
    if [[ -z ${QuNexBranch} ]]; then reho ""; reho "   Error: --branch flag not defined."; echo ""; gitqunex_usage; return 1; fi
    if [[ -z ${QuNexBranchPath} ]]; then reho ""; reho "   Error: --branchpath flag for specified branch not defined. Specify absolute path of the relevant Qu|Nex repo."; echo ""; gitqunex_usage; return 1; fi
    if [[ -z ${QuNexSubModulesList} ]]; then reho ""; reho "   Error: --submodules flag not not defined. Specify 'main', 'all' or specific submodule to commit."; echo ""; gitqunex_usage; return 1; fi
    if [[ ${QuNexSubModulesList} == "all" ]]; then reho ""; geho "   Note: --submodules flag set to all. Setting update for all submodules."; echo ""; fi
    if [[ ${QuNexSubModulesList} == "main" ]]; then reho ""; geho "   Note: --submodules flag set to main Qu|Nex repo only in $QuNexBranchPath"; echo ""; fi
    if [[ ${QuNexGitCommand} == "push" ]]; then
        if [[ -z ${CommitMessage} ]]; then reho ""; reho "   Error: --message flag missing. Please specify commit message."; echo ""; gitqunex_usage; return 1; else CommitMessage="${CommitMessage}"; fi
        if [[ -z ${QuNexAddFiles} ]]; then reho ""; reho "   Error: --add flag not defined. Run 'gitqunexstatus' and specify which files to add."; echo ""; gitqunex_usage; return 1; fi
    fi

    # -- Perform checks that Qu|Nex contains requested branch and that it is actively checked out
    cd ${QuNexBranchPath}
    echo ""
    mageho "  * Checking active branch for main Qu|Nex repo in $QuNexBranchPath..."
    echo ""
    if [[ -z `git branch | grep "${QuNexBranch}"` ]]; then reho "Error: Branch $QuNexBranch does not exist in $QuNexBranchPath. Check your repo."; echo ""; gitqunex_usage; return 1; else geho "   --> $QuNexBranch found in $QuNexBranchPath"; echo ""; fi
    if [[ -z `git branch | grep "* ${QuNexBranch}"` ]]; then reho "Error: Branch $QuNexBranch is not checked out and active in $QuNexBranchPath. Check your repo."; echo ""; gitqunex_usage; return 1; else geho "   --> $QuNexBranch is active in $QuNexBranchPath"; echo ""; fi
    mageho "  * All checks for main Qu|Nex repo passed."
    echo ""

    # -- Not perform further checks
    if [ "${QuNexSubModulesList}" == "main" ]; then
        echo ""
        geho "   Note: --submodules flag set to main Qu|Nex repo only. Omitting individual submodules."
        echo ""
        # -- Check git command
        echo ""
        geho "--- Running Qu|Nex git ${QuNexGitCommand} for ${QuNexBranch} on Qu|Nex main repo in ${QuNexBranchPath}."
        echo
        cd ${QuNexBranchPath}
        # -- Run a few git tests to verify LOCAL, REMOTE and BASE tips
        function_gitqunexbranch > /dev/null 2>&1
        # -- Check git command request
        if [[ ${QuNexGitCommand} == "pull" ]]; then
            cd ${QuNexBranchPath}; git pull origin ${QuNexBranch}
        fi
        if [[ ${QuNexGitCommand} == "push" ]]; then
            cd ${QuNexBranchPath}
            if [[ $LOCAL == $BASE ]] && [[ $LOCAL != $REMOTE ]]; then
                echo ""
                reho " --- LOCAL: $LOCAL equals BASE: $BASE but LOCAL mismatches REMOTE: $REMOTE. You need to pull your changes first. Run 'git status' and inspect changes."
                echo ""
                return 1
            else
                if [[ ${QuNexAddFiles} == "all" ]]; then
                    git add ./*
                else
                    git add ${QuNexAddFiles}
                fi
                git commit . --message="${CommitMessage}"
                git push origin ${QuNexBranch}
            fi
        fi
        function_gitqunexbranch
        echo ""
        geho "--- Completed Qu|Nex git ${QuNexGitCommand} for ${QuNexBranch} on Qu|Nex main repo in ${QuNexBranchPath}."; echo ""
        return 1
    fi

    # -- Check if all submodules are requested or only specific ones
    if [ ${QuNexSubModulesList} == "all" ]; then
        # -- Reset submodules variable to all
        unset QuNexSubModulesList
        QuNexSubModulesList=`cd $QUNEXPATH; git submodule status | awk '{ print $2 }' | sed 's/hcpextendedpull//' | sed '/^\s*$/d'`
        QuNexSubModules=${QuNexSubModulesList}
        if [[ ${QuNexAddFiles} != "all" ]] && [[ ${QuNexGitCommand} == "push" ]]; then
            reho "ERROR: Cannot specify all submodules and select files. Specify specific files for a given submodule or specify -add='all' "
            return 1
            gitqunex_usage
        else
            GitAddCommand="git add ./*"
        fi
    elif [ ${QuNexSubModulesList} == "main" ]; then
        echo ""
        geho "Note: --submodules flag set to the main Qu|Nex repo."
        echo ""
        QuNexSubModules="main"
        if [[ ${QuNexAddFiles} == "all" ]] && [[ ${QuNexGitCommand} == "push" ]]; then
            GitAddCommand="git add ./*"
        else
            GitAddCommand="git add ${QuNexAddFiles}"
        fi
    elif [[ ${QuNexSubModulesList} != "main*" ]] && [[ ${QuNexSubModulesList} != "all*" ]]; then
        QuNexSubModules=${QuNexSubModulesList}
        echo ""
        geho "Note: --submodules flag set to selected Qu|Nex repos: $QuNexSubModules"
        echo ""
        if [[ ${QuNexAddFiles} != "all" ]] && [[ ${QuNexGitCommand} == "push" ]]; then
            if [[ `echo ${QuNexSubModules} | wc -w` != 1 ]]; then 
                reho "Note: More than one submodule requested"
                reho "ERROR: Cannot specify several submodules and select specific files. Specify specific files for a given submodule or specify -add='all' "
                return 1
            fi 
            GitAddCommand="git add ${QuNexAddFiles}"
        else
            GitAddCommand="git add ./*"
        fi
    fi

    # -- Continue with specific submodules
    echo ""
    mageho "  * Checking active branch ${QuNexBranch} for specified submodules in ${QuNexBranchPath}... "
    echo ""
    for QuNexSubModule in ${QuNexSubModules}; do
        cd ${QuNexBranchPath}/${QuNexSubModule}
        if [[ -z `git branch | grep "${QuNexBranch}"` ]]; then reho "Error: Branch $QuNexBranch does not exist in $QuNexBranchPath/$QuNexSubModule. Check your repo."; echo ""; gitqunex_usage; return 1; else geho "   --> $QuNexBranch found in $QuNexBranchPath/$QuNexSubModule"; echo ""; fi
        if [[ -z `git branch | grep "* ${QuNexBranch}"` ]]; then reho "Error: Branch $QuNexBranch is not checked out and active in $QuNexBranchPath/$QuNexSubModule. Check your repo."; echo ""; gitqunex_usage; return 1; else geho "   --> $QuNexBranch is active in $QuNexBranchPath/$QuNexSubModule"; echo ""; fi
    done
    mageho "  * All checks passed for specified submodules... "
    echo ""
    # -- First run over specific modules
    for QuNexSubModule in ${QuNexSubModules}; do
        echo ""
        geho "--- Running Qu|Nex git ${QuNexGitCommand} for ${QuNexBranch} on Qu|Nex submodule ${QuNexBranchPath}/${QuNexSubModule}."
        echo
        cd ${QuNexBranchPath}/${QuNexSubModule}
        # -- Run a few git tests to verify LOCAL, REMOTE and BASE tips
        function_gitqunexbranch > /dev/null 2>&1
        # -- Check git command requests
        if [[ ${QuNexGitCommand} == "pull" ]]; then
            cd ${QuNexBranchPath}/${QuNexSubModule}; git pull origin ${QuNexBranch}
        fi
        if [[ ${QuNexGitCommand} == "push" ]]; then
            if [[ $LOCAL == $BASE ]] && [[ $LOCAL != $REMOTE ]]; then
                echo ""
                reho " --- LOCAL: $LOCAL equals BASE: $BASE but LOCAL mismatches REMOTE: $REMOTE. You need to pull your changes first. Run 'git status' and inspect changes."
                echo ""
                return 1
            else
                cd ${QuNexBranchPath}/${QuNexSubModule}
                eval ${GitAddCommand}
                git commit . --message="${CommitMessage}"
                git push origin ${QuNexBranch}
            fi
        fi
        function_gitqunexbranch
        echo ""
        geho "--- Completed Qu|Nex git ${QuNexGitCommand} for ${QuNexBranch} on Qu|Nex submodule ${QuNexBranchPath}/${QuNexSubModule}."; echo ""; echo ""
    done
    unset QuNexSubModule

    # -- Finish up with the main submodule after individual modules are committed
    echo ""
    geho "--- Running Qu|Nex git ${QuNexGitCommand} for ${QuNexBranch} on Qu|Nex main repo in ${QuNexBranchPath}."
    echo
    cd ${QuNexBranchPath}
    function_gitqunexbranch > /dev/null 2>&1
    # -- Check git command request
    if [[ ${QuNexGitCommand} == "pull" ]]; then
        cd ${QuNexBranchPath}; git pull origin ${QuNexBranch}
    fi
    if [[ ${QuNexGitCommand} == "push" ]]; then
        cd ${QuNexBranchPath}
            if [[ $LOCAL == $BASE ]] && [[ $LOCAL != $REMOTE ]]; then
            echo ""
                reho " --- LOCAL: $LOCAL equals BASE: $BASE but LOCAL mismatches REMOTE: $REMOTE. You need to pull your changes first. Run 'git status' and inspect changes."
            echo ""
            return 1
        else
            git add ./*
            git commit . --message="${CommitMessage}"
            git push origin ${QuNexBranch}
        fi
    fi
    function_gitqunexbranch
    echo ""
    geho "--- Completed Qu|Nex git ${QuNexGitCommand} for ${QuNexBranch} on Qu|Nex main repo in ${QuNexBranchPath}."; echo ""

    # -- Report final completion
    echo ""
    geho "=============== Completed Qu|Nex $QuNexGitCommand function ============== "
    echo ""

    # -- Reset submodules variable
    unset QuNexSubModules
    QuNexSubModules=`cd $QUNEXPATH; git submodule status | awk '{ print $2 }' | sed 's/hcpextendedpull//' | sed '/^\s*$/d'`
    unset QuNexBranch
    unset QuNexGitCommand
    unset QuNexBranchPath
    unset CommitMessage
    unset GitStatus
    unset QuNexSubModulesList
    unset QuNexSubModule
}

# -- define function_gitqunex alias
alias gitqunex=function_gitqunex

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

QuNexEnvCheck=`source ${TOOLS}/${QUNEXREPO}/library/environment/qunex_envStatus.sh --envstatus | grep "ERROR"` > /dev/null 2>&1
if [[ -z ${QuNexEnvCheck} ]]; then
    geho " ---> Qu|Nex environment set successfully!"
    echo ""
else
    reho "   --> ERROR in Qu|Nex environment. Run 'qunex_envstatus' to check missing variables!"
    echo ""
fi

