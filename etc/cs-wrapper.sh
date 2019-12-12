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
# * This Software conforms to the license outlined in the Qu|Nex Suite:
# * https://bitbucket.org/oriadev/qunex/src/master/LICENSE.md
#
# ### TODO
#
#
# ## Description 
#   
# This script serves as the container service parsing of input for the main Qu|Nex wrapper
# 
# ## Prerequisite Installed Software
#
# * Qu|Nex Suite
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

# -- Output folder check
#if [[ -z ${WORKDIR} ]]; then WORKDIR="/output"; fi
#if [[ -z ${OutputFolder} ]]; then OutputFolder="/output"; fi
if [[ -z ${OutputFolder} ]]; then OutputFolder="/gpfs/project/fas/n3/output2"; fi

# -- Full Qu|Nex command
CSWrapperCmd="$TOOLS/qunex/connector/qunex.sh runTurnkey \
--xnathost=${XNAT_HOST} \
--xnatuser=${XNAT_USER} \
--xnatpass=${XNAT_PASS} \
--studyfolder=${OutputFolder} \
${CSInputString}"

echo ""
echo "Qu|Nex Container Service Parsed Qu|Nex Command:"
echo "-----------------------------------------------"
echo ""
echo $CSWrapperCmd
echo ""

eval $CSWrapperCmd
