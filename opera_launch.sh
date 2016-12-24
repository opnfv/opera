#!/bin/bash
##############################################################################
# Copyright (c) 2016 HUAWEI TECHNOLOGIES CO.,LTD and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################
set -ex
OPERA_DIR=`cd ${BASH_SOURCE[0]%/*}/;pwd`
OPENO_DIR=${OPERA_DIR}/open-o
JUJU_DIR=${OPERA_DIR}/juju
WORK_DIR=${OPERA_DIR}/work
UTIL_DIR=${OPERA_DIR}/util

export DEPLOY_FIRST_TIME=${DEPLOY_FIRST_TIME:-"true"}
source ${OPERA_DIR}/conf/openo-vm.conf
source ${OPERA_DIR}/conf/openo-docker.conf
source ${UTIL_DIR}/log.sh
source ${OPENO_DIR}/openo_vm.sh

mkdir -p $WORK_DIR

if [[ "$DEPLOY_FIRST_TIME" == "true" ]]; then
    package_prepare
    network_prepare
fi

if ! openo_download_iso; then
    log_error "openo_download_iso failed"
fi

tear_down_openo

if ! launch_openo_vm; then
    log_error "launch_openo_vm failed"
fi

if ! launch_openo_docker; then
    log_error "launch_openo_docker failed"
fi

set +ex
