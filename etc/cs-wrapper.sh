#!/bin/bash -i
/opt/mnaptools/connector/functions/RunTurnkey.sh ${@:1} --xnathost=$XNAT_HOST --xnatuser=$XNAT_USER --xnatpass=$XNAT_PASS
