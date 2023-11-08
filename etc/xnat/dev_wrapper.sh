#!/bin/bash -i
#Wrapper used for qunex development on Xnat
#pulls in updated scripts from the projects level and replaces the old ones, then executes the main cs_wrapper.sh

echo ""
echo "QUNEX DEV WRAPPER START:"
echo "-----------------------------------------------"
echo ""

curl -k -u ${XNAT_USER}:${XNAT_PASS} -X GET "${XNAT_HOST}/data/archive/projects/${XNAT_PROJECT}/resources/QUNEX_SCRIPTS/files?format=zip" > ~/QUNEX_SCRIPTS.zip
cd ~
unzip -j QUNEX_SCRIPTS.zip
bash move.sh
rm QUNEX_SCRIPTS.zip
rm move.sh

echo ""
echo "QUNEX DEV WRAPPER END:"
echo "-----------------------------------------------"
echo ""

#Execute cs_wrapper
chmod 770 /opt/qunex/qx_library/etc/xnat/cs_wrapper.sh
bash /opt/qunex/qx_library/etc/xnat/cs_wrapper.sh
