#!/bin/bash -i
/opt/qunex/connector/qunex.sh ${@:1} --function='runTurnkey' --xnathost=${XNAT_HOST} --xnatuser=${XNAT_USER} --xnatpass=${XNAT_PASS}