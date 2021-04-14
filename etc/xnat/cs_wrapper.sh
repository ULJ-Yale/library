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

# -- Full QuNex command
CSWrapperCmd="$TOOLS/qunex/bin/qunex.sh run_turnkey \
--xnathost=${XNAT_HOST} \
--xnatuser=${XNAT_USER} \
--xnatpass=${XNAT_PASS} \
${CSInputString}"

echo ""
echo "QuNex Container Service Parsed QuNex Command:"
echo "-----------------------------------------------"
echo ""
echo $CSWrapperCmd
echo ""

eval $CSWrapperCmd
