#!/bin/bash -i
#
# SPDX-FileCopyrightText: 2021 QuNex development team <https://qunex.yale.edu/>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
#~ND~FORMAT~MARKDOWN~
#~ND~START~
#
# ## PRODUCT
#
#  cs-wrapper.sh
#
# ## Description 
#   
# This script serves as the container service parsing of input for the main QuNex wrapper
# 
# ## Prerequisite Installed Software
#
# * QuNex Suite
#
# ## Prerequisite Environment Variables
#
# XNAT environment
#
# ### Expected Previous Processing
# 
#
#~ND~END~

# -- String parsed from XNAT Container Service
CSInputString="${@:1}"

mkdir /output/${XNAT_PROJECT}
export STUDY_FOLDER=/output/${XNAT_PROJECT}
export SESSIONS_FOLDER=${STUDY_FOLDER}/sessions

#Run create study to setup correct folder structure

CSWrapperCmd="$TOOLS/qunex/bin/qunex.sh create_study \
    --studyfolder=${STUDY_FOLDER}"

echo ""
echo "QuNex Container Service Parsed QuNex Command:"
echo "-----------------------------------------------"
echo ""
echo $CSWrapperCmd
echo ""

eval $CSWrapperCmd

mkdir $SESSIONS_FOLDER/$LABEL
mkdir $SESSIONS_FOLDER/$LABEL/inbox
mkdir $SESSIONS_FOLDER/checkpoints

export RECIPE_FILE=${SESSIONS_FOLDER}/specs/${RECIPE_FILENAME}
export INITIAL_PARAMETERS=${SESSIONS_FOLDER}/specs/${BATCH_PARAMETERS_FILENAME}
export MAPPING=${SESSIONS_FOLDER}/specs/${SCAN_MAPPING_FILENAME}
export BATCH_PARAMETERS=${STUDY_FOLDER}/processing/batch.txt

#Pulls in recipe from project level
curl -k -u ${XNAT_USER}:${XNAT_PASS} -X GET "${XNAT_HOST}/data/projects/${XNAT_PROJECT}/resources/QUNEX_PROC/files/${RECIPE_FILENAME}" > $RECIPE_FILE

#For qunex development without updating container, pulls in scripts located in QUNEX_SCRIPTS at the project level
#QUNEX_SCRIPTS must contain a bash script called dev_wrapper.sh, which the main cs_wrapper runs
#This can then be used to update QuNex scripts or whatever else is necessary
if [[ $DEVELOP = yes ]]; then
    curl -k -u ${XNAT_USER}:${XNAT_PASS} -X GET "${XNAT_HOST}/data/archive/projects/${XNAT_PROJECT}/resources/QUNEX_SCRIPTS/files?format=zip" > ~/QUNEX_SCRIPTS.zip
    cd ~
    unzip -j QUNEX_SCRIPTS.zip
    chmod 770 dev_wrapper.sh
    bash dev_wrapper.sh
    cd $STUDY_FOLDER
fi

#Allows for recipes to be comma seperated and run in legacy 'run_turnkey' fashion. Runs as normal if just one recipe is supplied sans comma
IFS=',' read -ra recipeArray <<< "$RECIPES"
for RECIPE in "${recipeArray[@]}"; do 
    echo "Running recipe: ${RECIPE}"
    CSWrapperCmd="$TOOLS/qunex/bin/qunex.sh run_recipe \
        --recipe_file=${RECIPE_FILE} \
        --recipe=${RECIPE} \
        ${CSInputString}"

    echo ""
    echo "QuNex Container Service Parsed QuNex Command:"
    echo "-----------------------------------------------"
    echo ""
    echo $CSWrapperCmd
    echo ""

    eval $CSWrapperCmd
    unset XNAT_CHECKPOINT
done


COM_LOGS_DIR="/output/${XNAT_PROJECT}/processing/logs/comlogs"

ERROR_FILE_COUNT=`find ${COM_LOGS_DIR} -name "error_*"| wc | awk '{print $1}'`

if [[ ${ERROR_FILE_COUNT} -eq 0 ]]; then
    exit 0
else
    exit 1
fi
