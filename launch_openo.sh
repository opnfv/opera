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
OPENO_DIR=`cd ${BASH_SOURCE[0]%/*}/;pwd`
WORK_DIR=${OPENO_DIR}/work

source ${OPENO_DIR}/conf/openo-vm.conf
source ${OPENO_DIR}/conf/openo-docker.conf
source ${OPENO_DIR}/log.sh
source ${OPENO_DIR}/openo_vm.sh

mkdir -p $WORK_DIR

if ! download_iso; then
    log_error "download_iso failed"
fi

tear_down_openo

if ! launch_openo; then
    log_error "launch_openo failed"
fi

if ! launch_docker; then
    log_error "launch_docker failed"
fi

set +ex
