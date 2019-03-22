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
#  mnap_envStatus.sh
#
# ## LICENSE
#
# * The mnap_envStatus.sh = the "Software"
# * This Software conforms to the license outlined in the MNAP Suite:
# * https://bitbucket.org/hidradev/mnaptools/src/master/LICENSE.md
#
# ## TODO
#
#
# ## DESCRIPTION:
#
# * This a script designed to check MNAP suite environment setup
#
# ## PREREQUISITE INSTALLED SOFTWARE
#
# * MNAP Suite
#
# ## PREREQUISITE ENVIRONMENT VARIABLES
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

# ------------------------------------------------------------------------------
# -- General help usage function
# ------------------------------------------------------------------------------

usage() {
    echo ""
    echo "-- DESCRIPTION:  This a script designed to report status or clear the MNAP suite environment variables."
    echo ""
    echo " --envstatus           Reports the status of all environment variables (also supports --envreport or --environment)"
    echo " --envclear            Clears all environment variables (also supports --envreset or --envpurge)"
    echo ""
}

######################################### DO WORK ##########################################

main() {

# -- Clear MNAP environment

# -- Hard reset for the environment in the container manually
     #
     #   Useful links on how to rename variables to be passe back to parent shell: 
     #   --> https://unix.stackexchange.com/questions/129084/in-bash-how-can-i-echo-the-variable-name-not-the-variable-value
     #   --> https://stackoverflow.com/questions/23564995/how-to-modify-a-global-variable-within-a-function-in-bash
     #

if [[ "$1" == "--envreset" ]] || [[ "$1" == "--envclear" ]] || [[ "$1" == "--envpurge" ]]; then
    unset $ENVVARIABLES
    echo ""
    reho " ---> Requested a hard reset of the MNAP environment! "
    echo ""
    for ENVVARIABLE in ${ENVVARIABLES}; do 
        reho " --> Unsetting ${ENVVARIABLE}"
        EnvVarName=(${!ENVVARIABLE@})
        unset $EnvVarName
        if [ -z ${ENVVARIABLE+x} ]; then 
            geho "     --> Unset successful: $ENVVARIABLE"; 
        else 
            reho "     --> $ENVVARIABLE is still set!"; 
        fi
    done
    echo ""
fi

# -- Check MNAP environment

if [[ "$1" == "--envstatus" ]] || [[ "$1" == "--envreport" ]] || [[ "$1" == "--env" ]] || [[ "$1" == "--environment" ]]; then
    echo ""
    geho "--------------------------------------------------------------"
    geho " MNAP Environment Status Report"
    geho "--------------------------------------------------------------"
    unset EnvErrorReport
    unset EnvError
    echo ""
    echo ""
    echo ""
    geho "   MNAP General Environment Variables"
    geho "----------------------------------------------"
    echo ""
    echo "                  MNAPVer : $MNAPVer";              if [[ -z $MNAPVer ]]; then EnvError="yes"; EnvErrorReport="MNAPVer"; fi
    echo "                    TOOLS : $TOOLS";                if [[ -z $TOOLS ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport TOOLS"; fi
    echo "                 MNAPREPO : $MNAPREPO";             if [[ -z $MNAPREPO ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport MNAPREPO"; fi
    echo "                 MNAPPATH : $MNAPPATH";             if [[ -z $MNAPPATH ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport MNAPPATH"; fi
    echo "                  MNAPENV : $MNAPENV";              if [[ -z $MNAPENV ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport MNAPENV"; fi
    echo "           TemplateFolder : $TemplateFolder";       if [[ -z $TemplateFolder ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport TemplateFolder"; fi
    echo "             MNAPMCOMMAND : $MNAPMCOMMAND";         if [[ -z $MNAPMCOMMAND ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport MNAPMCOMMAND"; fi
    echo ""
    geho "   Core Dependencies Environment Variables"
    geho "----------------------------------------------"
    echo ""
    echo "                 CONDADIR : $CONDADIR";             if [[ -z $CONDADIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport CONDADIR"; fi
    echo "                   FSLDIR : $FSLDIR";               if [[ -z $FSLDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport FSLDIR"; fi
    echo "                FSLGPUDIR : $FSLGPUDIR";            if [[ -z $FSLGPUDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport FSLGPUDIR"; fi
    echo "             FSLGPUBinary : $FSLGPUBinary";         if [[ -z $FSLGPUBinary ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport FSLGPUBinary"; fi
    echo "               FSL_FIXDIR : $FSL_FIXDIR";           if [[ -z $FSL_FIXDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport FSL_FIXDIR"; fi
    echo "            POSTFIXICADIR : $POSTFIXICADIR";        if [[ -z $POSTFIXICADIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport POSTFIXICADIR"; fi
    echo "          FREESURFER_HOME : $FREESURFER_HOME";      if [[ -z $FREESURFER_HOME ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport FREESURFER_HOME"; fi
    echo "     FREESURFER_SCHEDULER : $FREESURFER_SCHEDULER"; if [[ -z $FREESURFER_SCHEDULER ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport FREESURFER_SCHEDULER"; fi
    echo "             WORKBENCHDIR : $WORKBENCHDIR";         if [[ -z $WORKBENCHDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport WORKBENCHDIR"; fi
    echo "                CARET7DIR : $CARET7DIR";            if [[ -z $CARET7DIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport CARET7DIR"; fi
    echo "                  AFNIDIR : $AFNIDIR";              if [[ -z $AFNIDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport AFNIDIR"; fi
    echo "                DCMNIIDIR : $DCMNIIDIR";            if [[ -z $DCMNIIDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport DCMNIIDIR"; fi
    echo "               DICMNIIDIR : $DICMNIIDIR";           if [[ -z $DICMNIIDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport DICMNIIDIR"; fi
    if [ "$USEOCTAVE" == "TRUE" ]; then
    echo "                OCTAVEDIR : $OCTAVEDIR";            if [[ -z $OCTAVEDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport OCTAVEDIR"; fi
    echo "             OCTAVEPKGDIR : $OCTAVEPKGDIR";         if [[ -z $OCTAVEPKGDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport OCTAVEPKGDIR"; fi
    echo "             OCTAVEBINDIR : $OCTAVEBINDIR";         if [[ -z $OCTAVEBINDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport OCTAVEBINDIR"; fi
    else
    echo "                MATLABDIR : $MATLABDIR";            if [[ -z $MATLABDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport MATLABDIR"; fi
    echo "             MATLABBINDIR : $MATLABBINDIR";         if [[ -z $MATLABBINDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport MATLABBINDIR"; fi
    fi
    echo "                     RDIR : $RDIR";                 if [[ -z $RDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport RDIR"; fi
    echo "                  PALMDIR : $PALMDIR";              if [[ -z $PALMDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport PALMDIR"; fi
    echo ""
    geho "   HCP Pipelines Environment Variables"
    geho "----------------------------------------------"
    echo ""
    echo "               HCPPIPEDIR : $HCPPIPEDIR";               if [[ -z $HCPPIPEDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR"; fi
    echo "            GRADUNWARPDIR : $GRADUNWARPDIR";            if [[ -z $GRADUNWARPDIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport GRADUNWARPDIR"; fi
    echo "     HCPPIPEDIR_Templates : $HCPPIPEDIR_Templates";     if [[ -z $HCPPIPEDIR_Templates ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_Templates"; fi
    echo "           HCPPIPEDIR_Bin : $HCPPIPEDIR_Bin";           if [[ -z $HCPPIPEDIR_Bin ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_Bin"; fi
    echo "        HCPPIPEDIR_Config : $HCPPIPEDIR_Config";        if [[ -z $HCPPIPEDIR_Config ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_Config"; fi
    echo "         HCPPIPEDIR_PreFS : $HCPPIPEDIR_PreFS";         if [[ -z $HCPPIPEDIR_PreFS ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_PreFS"; fi
    echo "            HCPPIPEDIR_FS : $HCPPIPEDIR_FS";            if [[ -z $HCPPIPEDIR_FS ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_FS"; fi
    echo "        HCPPIPEDIR_PostFS : $HCPPIPEDIR_PostFS";        if [[ -z $HCPPIPEDIR_PostFS ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_PostFS"; fi
    echo "      HCPPIPEDIR_fMRISurf : $HCPPIPEDIR_fMRISurf";      if [[ -z $HCPPIPEDIR_fMRISurf ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_fMRISurf"; fi
    echo "       HCPPIPEDIR_fMRIVol : $HCPPIPEDIR_fMRIVol";       if [[ -z $HCPPIPEDIR_fMRIVol ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_fMRIVol"; fi
    echo "         HCPPIPEDIR_tfMRI : $HCPPIPEDIR_tfMRI";         if [[ -z $HCPPIPEDIR_tfMRI ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_tfMRI"; fi
    echo "          HCPPIPEDIR_dMRI : $HCPPIPEDIR_dMRI";          if [[ -z $HCPPIPEDIR_dMRI ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_dMRI"; fi
    echo "     HCPPIPEDIR_dMRITract : $HCPPIPEDIR_dMRITract";     if [[ -z $HCPPIPEDIR_dMRITract ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_dMRITract"; fi
    echo "        HCPPIPEDIR_Global : $HCPPIPEDIR_Global";        if [[ -z $HCPPIPEDIR_Global ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_Global"; fi
    echo " HCPPIPEDIR_tfMRIAnalysis : $HCPPIPEDIR_tfMRIAnalysis"; if [[ -z $HCPPIPEDIR_tfMRIAnalysis ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_tfMRIAnalysis"; fi
    echo "                   MSMBin : $MSMBin";                   if [[ -z $MSMBin ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport MSMBin"; fi
    echo "  HCPPIPEDIR_dMRITracFull : $HCPPIPEDIR_dMRITracFull";  if [[ -z $HCPPIPEDIR_dMRITracFull ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_dMRITracFull"; fi
    echo "    HCPPIPEDIR_dMRILegacy : $HCPPIPEDIR_dMRILegacy";    if [[ -z $HCPPIPEDIR_dMRILegacy ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport HCPPIPEDIR_dMRILegacy"; fi
    echo "            AutoPtxFolder : $AutoPtxFolder";            if [[ -z $AutoPtxFolder ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport AutoPtxFolder"; fi
    echo "              EDDYCUDADIR : $EDDYCUDADIR";              if [[ -z $EDDYCUDADIR ]]; then EnvError="yes"; EnvErrorReport="$EnvErrorReport EDDYCUDADIR"; fi
    echo ""
    echo ""
    geho "   Binary / Executable Locations and Versions"
    geho "----------------------------------------------"
    echo ""
    
    unset BinaryErrorReport
    unset BinaryError
    
    ## -- Check for FSL
    echo "         FSL Binary  : $(which fsl 2>&1 | grep -v 'no fsl')"
    if [[ -z $(which fsl 2>&1 | grep -v 'no fsl') ]]; then 
        BinaryError="yes"; BinaryErrorReport="fsl"
        reho "         FSL Version : Binary not found!"
        if [[ -L "$FSLDIR"  && ! -e "$FSLDIR" ]]; then
            reho "                     : $FSLDIR is a link to a nonexisiting folder!"
        fi
    else
        echo "         FSL Version : $(cat $FSLDIR/etc/fslversion)"
    fi
    echo ""

    ## -- Check for FreeSurfer
    echo "  FreeSurfer Binary  : $(which freesurfer 2>&1 | grep -v 'no freesurfer')"
    if [[ -z $(which freesurfer 2>&1 | grep -v 'no freesurfer') ]]; then 
        BinaryError="yes"; BinaryErrorReport="$BinaryErrorReport freesurfer"
        reho "  FreeSurfer Version : Binary not found!"
        if [[ -L "$FREESURFER_HOME"  && ! -e "$FREESURFER_HOME" ]]; then
            reho "                     : $FREESURFER_HOME is a link to a nonexisiting folder!"
        fi
    else
        echo "  FreeSurfer Version : $(freesurfer | tail -n 2)"
    fi
    echo ""

    ## -- Check for AFNI
    if [ ! -f /opt/.container ]; then
        echo "        AFNI Binary  : $(which afni 2>&1 | grep -v 'no afni')"
        if [[ -z $(which afni 2>&1 | grep -v 'no afni') ]]; then 
            BinaryError="yes"; BinaryErrorReport="$BinaryErrorReport afni"
            reho "        AFNI Version : Binary not found!"
            if [[ -L "$AFNIDIR"  && ! -e "$AFNIDIR" ]]; then
                reho "                     : $AFNIDIR is a link to a nonexisiting folder!"
            fi
        else
            echo "        AFNI Version : $(afni --version)"
        fi
        echo ""
    fi

    ## -- Check for dcm2niix
    echo "    dcm2niix Binary  : $(which dcm2niix 2>&1 | grep -v 'no dcm2niix')"
    if [[ -z $(which dcm2niix 2>&1 | grep -v 'no dcm2niix') ]]; then 
        BinaryError="yes"; BinaryErrorReport="$BinaryErrorReport dcm2niix"
        reho "    dcm2niix Version : Binary not found!"
        if [[ -L "$DCMNIIDIR"  && ! -e "$DCMNIIDIR" ]]; then
            reho "                     : $DCMNIIDIR is a link to a nonexisiting folder!"
        fi
    else
        echo "    dcm2niix Version : $(dcm2niix -v | head -1)"
    fi
    echo ""

    ## -- Check for dicm2nii only if outside the container
    if [ ! -f /opt/.container ]; then
        echo "    dicm2nii Binary  : $DICMNIIDIR/dicm2nii.m"
        if [[ -z `ls $DICMNIIDIR/dicm2nii.m 2> /dev/null` ]]; then 
            BinaryError="yes"; BinaryErrorReport="$BinaryErrorReport dicm2nii"
            reho "    dicm2nii Version : Executable not found!"
            if [[ -L "$DICMNIIDIR"  && ! -e "$DICMNIIDIR" ]]; then
                reho "                     : $DICMNIIDIR is a link to a nonexisiting folder!"
            fi
        else    
            echo "    dicm2nii Version : $(cat $DICMNIIDIR/README.md | grep "(version" )"
        fi
        echo ""
    fi

    ## -- Check for fix
    if [ ! -f /opt/.container ]; then
        echo "         FIX Binary  : $(which fix 2>&1 | grep -v 'no fix')"
        if [[ -z $(which fix 2>&1 | grep -v 'no fix') ]]; then 
            BinaryError="yes"; BinaryErrorReport="$BinaryErrorReport fix"
            reho "         FIX Version : Binary not found!"
            if [[ -L "$FSL_FIXDIR"  && ! -e "$FSL_FIXDIR" ]]; then
                reho "                     : $FSL_FIXDIR is a link to a nonexisiting folder!"
            fi
        else
            echo "         FIX Version : $(fix -v | grep FMRIB)"
        fi
        echo ""
    fi

    ## -- Check for Octave
    if [ "$USEOCTAVE" == "TRUE" ]; then
        echo "      Octave Binary  : $(which octave 2>&1 | grep -v 'no octave')"
        if [[ -z $(which octave 2>&1 | grep -v 'no octave') ]]; then 
            BinaryError="yes"; BinaryErrorReport="$BinaryErrorReport octave"
            reho "      Octave Version : Binary not found!"
            if [[ -L "$OCTAVEBINDIR"  && ! -e "$OCTAVEBINDIR" ]]; then
                reho "                     : $OCTAVEBINDIR is a link to a nonexisiting folder!"
            fi
        else
            echo "      Octave Version : $(octave -q --eval "v=version;fprintf('%s', v);")"
        fi
    else
        echo "      Matlab Binary  : $(which matlab 2>&1 | grep -v 'no matlab')"
        if [[ -z $(which matlab 2>&1 | grep -v 'no matlab') ]]; then
            BinaryError="yes"; BinaryErrorReport="$BinaryErrorReport matlab"
            reho "      Matlab Version : Binary not found!"
            if [[ -L "$MATLABDIR"  && ! -e "$MATLABDIR" ]]; then
                reho "                     : $MATLABDIR is a link to a nonexisiting folder!"
            fi
        else
            echo "      Matlab Version : $(which matlab 2>&1 | grep -v 'no matlab')"
        fi
        # echo "     matlab : $(matlab -nodisplay -nojvm -nosplash -r "v=version;fprintf('%s', v);" | tail -1)"  
    fi
    echo ""

    ## -- Check for R
    echo "            R Binary : $(which R 2>&1 | grep -v 'no R')"
        if [[ -z $(which R 2>&1 | grep -v 'no R') ]]; then
        BinaryError="yes"; BinaryErrorReport="$BinaryErrorReport R"
        reho "  R Version : Binary not found!"
        if [[ -L "$RDIR"  && ! -e "$RDIR" ]]; then
            reho "                     : $RDIR is a link to a nonexisiting folder!"
        fi
    else
        echo "           R Version : $(R --version | head -1)"
    fi
    echo ""
    
    ## -- Check for R packages that are required
    unset RPackageTest RPackage
    RPackages="ggplot2"   # <-- Add R packages here
    echo "           R required packages : ${RPackages}"
    for RPackage in ${RPackages}; do
        RPackageTest=`R --slave -e "tpkg <- '$RPackage'; if (is.element(tpkg, installed.packages()[,1])) {packageVersion(tpkg)} else {print('package not installed')}" | sed 's/\[1\]//g'`
        if [[ `echo ${RPackageTest} | grep 'not installed'` ]]; then 
                reho "  R Package : ${RPackage} not installed!"
        else
                echo "           R Package : ${RPackage} ${RPackageTest}"
        fi
    done
    echo ""
        
    ## -- Check for PALM
    echo "        PALM Binary  : $PALMDIR/palm.m"
    if [[ -z `ls $PALMDIR/palm.m 2> /dev/null` ]]; then 
        BinaryError="yes"; BinaryErrorReport="$BinaryErrorReport palm"
        reho "        PALM Version : Executable not found!"
        if [[ -L "$PALMDIR"  && ! -e "$PALMDIR" ]]; then
            reho "                     : $PALMDIR is a link to a nonexisiting folder!"
        fi
    else
        echo "        PALM Version : $(cat $PALMDIR/palm_version.txt)"
    fi
    echo ""

    ## -- Check for Workbench
    echo "  wb_command Binary  : $(which wb_command 2>&1 | grep -v 'no wb_command')"
        if [[ -z $(which wb_command 2>&1 | grep -v 'no wb_command') ]]; then
        BinaryError="yes"; BinaryErrorReport="$BinaryErrorReport wb_command"
        reho "  wb_command Version : Binary not found!"
        if [[ -L "$WORKBENCHDIR"  && ! -e "$WORKBENCHDIR" ]]; then
            reho "                     : $WORKBENCHDIR is a link to a nonexisiting folder!"
        fi
    else
        echo "  wb_command Version : $(wb_command | head -1)"
    fi
    echo ""

    geho "  Full Environment Paths"
    geho "----------------------------------------------"
    echo ""
    echo "  PATH : $PATH"
    echo ""
    echo "  PYTHONPATH : $PYTHONPATH"
    echo ""
    echo "  MATLABPATH : $MATLABPATH"
    echo ""
    
    if [[ ${EnvError} == "yes" ]]; then
        echo ""
        reho "  ERROR: The following environment variable(s) are missing: ${EnvErrorReport}"
        echo ""
    elif [[ ${BinaryError} == "yes" ]]; then
        echo ""
        reho "  ERROR: The following binaries / executables are not found: ${BinaryErrorReport}"
        echo ""
    else
        echo ""
        geho "=================== MNAP environment set successfully! ===================="
        echo ""
    fi
fi

}

# ---------------------------------------------------------
# -- Invoke the main function to get things started -------
# ---------------------------------------------------------

main $@
