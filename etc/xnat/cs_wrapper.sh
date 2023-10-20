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

mkdir /output/${XNAT_PROJECT}
export STUDY_FOLDER=/output/${XNAT_PROJECT}
export SESSIONS_FOLDER=${STUDY_FOLDER}/sessions

CSWrapperCmd="$TOOLS/qunex/bin/qunex.sh create_study \
    --studyfolder=${STUDY_FOLDER}"

echo ""
echo "QuNex Container Service Parsed QuNex Command:"
echo "-----------------------------------------------"
echo ""
echo $CSWrapperCmd
echo ""

eval $CSWrapperCmd

curl -k -u ${XNAT_USER_NAME}:${XNAT_PASSWORD} -X GET "${XNAT_HOST_NAME}/data/projects/${XNAT_PROJECT}/resources/QUNEX_PROC/files/${RECIPE_FILENAME}" > ${SESSIONS_FOLDER}/specs/${RECIPE_FILENAME}

#For Xnat testing
export XNAT_SCRIPTS_FOLDER=${SESSIONS_FOLDER}/specs/xnat
mkdir ${XNAT_SCRIPTS_FOLDER}
curl -k -u ${XNAT_USER_NAME}:${XNAT_PASSWORD} -X GET "${XNAT_HOST_NAME}/data/archive/projects/${XNAT_PROJECT}/resources/BASH_SCRIPTS/files?format=zip" > ${XNAT_SCRIPTS_FOLDER}/BASH_SCRIPTS.zip
cd $XNAT_SCRIPTS_FOLDER
unzip -j BASH_SCRIPTS.zip
rm BASH_SCRIPTS.zip
cd $STUDY_FOLDER

export RECIPE_FILE=${SESSIONS_FOLDER}/specs/${RECIPE_FILENAME}
export INITIAL_PARAMETERS=${SESSIONS_FOLDER}/specs/${BATCH_PARAMETERS_FILENAME}
export MAPPING=${SESSIONS_FOLDER}/specs/${SCAN_MAPPING_FILENAME}
export BATCH_PARAMETERS=${STUDY_FOLDER}/processing/${BATCH_PARAMETERS_FILENAME}

CSWrapperCmd="$TOOLS/qunex/bin/qunex.sh run_recipe \
    --recipe_file=${RECIPE_FILE} \
    --recipe=${RECIPE} \
    --xnat=yes"

echo ""
echo "QuNex Container Service Parsed QuNex Command:"
echo "-----------------------------------------------"
echo ""
echo $CSWrapperCmd
echo ""

eval $CSWrapperCmd

# Dicom cleanup

rm ${SESSIONS_FOLDER}/${LABEL}/dicom/*tar* &> /dev/null

# -- String parsed from XNAT Container Service
CSInputString="${@:1}"

COM_LOGS_DIR="/output/${XNAT_PROJECT}/processing/logs/comlogs"

ERROR_FILE_COUNT=`find ${COM_LOGS_DIR} -name "error_*"| wc | awk '{print $1}'`

if [[ ${ERROR_FILE_COUNT} -eq 0 ]]; then
    exit 0
else
    exit 1
fi
