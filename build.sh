#!/bin/bash
# Script to build image for qemu.
# Author: Siddhant Jajoo.

git submodule init
git submodule sync
git submodule update

# local.conf won't exist until this step on first execution
source poky/oe-init-build-env

CONFLINE="MACHINE = \"qemuarm64\""

cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf

else
	echo "${CONFLINE} already exists in the local.conf file"
fi

# NOTE: not from course lecture material — added to work around a CI-only
# failure where OE-core's sanity checker cannot reach
# https://www.yoctoproject.org/connectivity.html from inside the
# self-hosted runner's Docker container. Points the check at a reachable
# URL instead of disabling it outright, so a genuine network problem in
# CI still fails loudly rather than being silently ignored.
CONNLINE="CONNECTIVITY_CHECK_URIS = \"https://www.google.com/\""

cat conf/local.conf | grep "${CONNLINE}" > /dev/null
conn_info=$?

if [ $conn_info -ne 0 ];then
	echo "Append ${CONNLINE} in the local.conf file"
	echo ${CONNLINE} >> conf/local.conf

else
	echo "${CONNLINE} already exists in the local.conf file"
fi

bitbake-layers show-layers | grep "meta-aesd" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-aesd layer"
	bitbake-layers add-layer ../meta-aesd

else
	echo "meta-aesd layer already exists"
fi

set -e
bitbake core-image-aesd
