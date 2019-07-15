#!/bin/bash
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
# * Grega Repovs, MBLab, University of Ljubljana
# * Alan Anticevic, N3 Division, Yale University
# * Zailyn Tamayo, N3 Division, Yale University 
#
# ## PRODUCT
#
#  qunexContainer.sh
#
# ## LICENSE
#
# * The qunexContainer.sh = the "Software"
# * This Software conforms to the license outlined in the MNAP Suite:
# * https://bitbucket.org/hidradev/mnaptools/src/master/LICENSE.md
#
# ### TODO
#
#
# ## Description 
#   
# This script, qunexContainer.sh runs QuNex  container 
#  pointing to code that executes the environment and calls the final code 
#  that should be executed inside the container
# 
# ## Prerequisite Installed Software
#
# * QuNex Suite Docker or Singularity Container
#
# ## Prerequisite Environment Variables
#
# See output of usage function: e.g. bash qunexContainer.sh --help
#
# ### Expected Previous Processing
# 
#
#~ND~END~

usage() {
    echo ""
    echo "  -- DESCRIPTION:"
    echo ""
    echo "  This function implements the initialization of the QuNex container execution for Docker or Singularity."
    echo ""
    echo ""
    echo "  --container=<container image>             Specifies either the path to the Singularity container image "
    echo "                                            or the full specification of the Docker container to be used "
    echo "                                            (e.g. qunex/qunex_suite:0_45_07). This parameter can be  "
    echo "                                            omitted if the value is specified in the `QUNEXCONIMAGE` "
    echo "                                            environmental variable. "
    echo ""    
    echo "  --script=<location of execute script>     If a script is to be run agains the Singularity container "
    echo "                                            rather than a single command, the path to the script to be "
    echo "                                            run is specified here. [''] "
    echo ""
    echo "  --string=<qunex execution string>         String to execute the QuNex call"
    echo ""
    echo ""
    echo "  PARAMETERS FOR DOCKER I/O:"
    echo ""
    echo "  --studyfolder=<study_folder>              Path to study folder for Docker image"
    echo ""
    echo "  --outputfolder=<output_folder>            Path to output folder for Docker image"
    echo ""
    echo ""
    echo " "                          
    echo "   -- Command to execute the shell script:"
    echo " "
    echo "   <path to this script>/qunexContainer.sh \ " 
    echo "                         --container=<Type of container image> \ "
    echo "                         --script=<Path of the container folder> \ "
    echo "                         --studyfolder=<study_folder> \ "
    echo "                         --outputfolder=<output_folder> \ "
    echo ""
    exit 0
}

# ------------------------------------------------------------------------------
# -- Check for help
# ------------------------------------------------------------------------------

if [[ $1 == "" ]] || [[ $1 == "--help" ]] || [[ $1 == "-help" ]] || [[ $1 == "--usage" ]] || [[ $1 == "-usage" ]] || [[ $1 == "help" ]] || [[ $1 == "usage" ]]; then
    usage
fi

# ------------------------------------------------------------------------------
# -- Check for options
# ------------------------------------------------------------------------------

opts_GetOpt() {
sopt="$1"
shift 1
for fn in "$@" ; do
    if [ `echo $fn | grep -- "^${sopt}=" | wc -w` -gt 0 ]; then
        echo $fn | sed "s/^${sopt}=//"
        return 0
    fi
done
}

# =-=-=-=-=-= GENERAL OPTIONS =-=-=-=-=-=
#
# -- key variables to set
#

ConImage=`opts_GetOpt "--container" $@`
QUNEXscript=`opts_GetOpt "--script" $@`
QUNEXstring=`opts_GetOpt "--string" $@`
StudyFolder=`opts_GetOpt "--studyfolder" $@`
OutputFolder=`opts_GetOpt "--outputfolder" $@`

# -- Setup paths for scripts folder and container
if [[ -z ${QUNEXscript} ]] || [[ -z ${QUNEXstring} ]]; then reho "  --> Error: Qu|Nex execute call or script is missing."; exit 1; echo ''; fi
if [[ -z ${ConImage} ]]; then reho "  --> Error: Qu|Nex Container image input is missing."; exit 1; echo ''; fi
if [[ -z ${StudyFolder} ]]; then reho "  --> Error: Qu|Nex Study folder input is missing."; exit 1; echo ''; fi
if [[ -z ${OutputFolder} ]]; then reho "  --> Error: Qu|Nex Study folder input is missing."; exit 1; echo ''; fi

if [[ `echo ${ConImage} | grep '.simg' ` ]] || [[ `echo ${ConImage} | grep '.sif' ` ]]; then 
    Singularity="yes"
else
    Docker="yes"
fi

# -- Execute Singularity container
if [[ ${Singularity} == 'yes' ]] ; then 
   echo ""
   echo " -- Executing container image ${QUNEXCONIMAGEPath} with call: ${QUNEXRunCall}"
   echo ""
   singularity exec ${ConImage} bash ${QUNEXRunCall}
fi

# -- Execute Docker container
if [[ ${Docker} == 'yes' ]] ; then 
   
   echo ""
   echo " -- Executing Docker container image with call: ${QUNEXRunCall}"
   echo ""   
   # -- If script then parse folder name
   if [[ ! -z ${QUNEXscript} ]]; then
       ScriptsDir=$(dirname "${QUNEXscript}")
   fi
   echo "  -- Creating output folder $OutputFolder"; echo ""
   
   mkdir -p ${OutputFolder}
   docker rm -f ${OutName}
   
   # -- Check for String or Script
   if [[ ! -z ${QUNEXscript} ]]; then
       docker container run -d -v ${ScriptsDir}/:/data/scripts \
            -v ${StudyFolder}/:/data/input \
            -v ${OutputFolder}:/data/output \
            ${ConImage} bash -c "/data/scripts/${QUNEXscript}"
   fi
   if [[ ! -z ${QUNEXstring} ]]; then
       docker container run -d -v ${ScriptsDir}/:/data/scripts \
            -v ${StudyFolder}/:/data/input \
            -v ${OutputFolder}:/data/output \
             ${ConImage} bash -c "/opt/qunex/library/bin/qunex-api-wrapper.sh ${QUNEXString}"
   fi
fi
