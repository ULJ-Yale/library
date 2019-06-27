#!/bin/bash -i
/opt/qunex/connector/functions/RunTurnkey.sh ${@:1} --xnathost=${XNAT_HOST} --xnatuser=${XNAT_USER} --xnatpass=${XNAT_PASS}
