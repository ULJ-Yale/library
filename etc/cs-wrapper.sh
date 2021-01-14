#!/bin/bash -i
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
# * Alan Anticevic, N3 Division, Yale University
# * Zailyn Tamayo, N3 Division, Yale University 
# * Grega Repovs, MBLAB, University of Ljubljana
#
# ## PRODUCT
#
#  cs-wrapper.sh
#
# ## LICENSE
#
# * The cs-wrapper.sh = the "Software"
# * This Software conforms to the license outlined in the QuNex Suite:
# * https://bitbucket.org/oriadev/qunex/src/master/LICENSE.md
#
# ### TODO
#
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
CSWrapperCmd="$TOOLS/qunex/connector/qunex.sh runTurnkey \
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
