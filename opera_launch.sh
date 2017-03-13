#!/bin/bash
##############################################################################
# Copyright (c) 2016-2017 HUAWEI TECHNOLOGIES CO.,LTD and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################
set -ex
export OPERA_DIR=`cd ${BASH_SOURCE[0]%/*}/;pwd`
CONF_DIR=${OPERA_DIR}/conf
CSAR_DIR=${OPERA_DIR}/csar
UTIL_DIR=${OPERA_DIR}/util
OPENO_DIR=${OPERA_DIR}/open-o
JUJU_DIR=${OPERA_DIR}/juju
WORK_DIR=${OPERA_DIR}/work

export DEPLOY_FIRST_TIME=${DEPLOY_FIRST_TIME:-"true"}
export DEPLOY_OPENO=${DEPLOY_OPENO:-"true"}
export DEPLOY_JUJU=${DEPLOY_JUJU:-"true"}

source ${CONF_DIR}/admin-openrc.sh

source ${OPERA_DIR}/prepare.sh
source ${OPERA_DIR}/conf/juju.conf
source ${OPENO_DIR}/openo_docker.sh
source ${UTIL_DIR}/log.sh
source ${JUJU_DIR}/command.sh
source ${JUJU_DIR}/juju_setup.sh
source ${JUJU_DIR}/juju_launch.sh
source ${JUJU_DIR}/juju_connect.sh

mkdir -p $WORK_DIR

if [[ "$DEPLOY_FIRST_TIME" == "true" ]]; then
    prepare_env
fi

source ${WORK_DIR}/scripts/open-o.conf

#sudo sync && sudo sysctl -w vm.drop_caches=3

if [[ "$DEPLOY_OPENO" == "true" ]]; then
    if ! launch_openo;then
        log_error "deploy_openo failed"
        exit 1
    fi
fi

#sudo sync && sudo sysctl -w vm.drop_caches=3

if [[ "$DEPLOY_JUJU" == "true" ]]; then
    juju_env_prepare
    clear_juju_vm

    if ! juju_prepare; then
        log_error "juju_prepare failed"
        exit 1
    fi

    if ! launch_juju; then
        log_error "launch_juju failed"
        exit 1
    fi
    connect_juju_and_openo
fi

figlet -ctf slant Open-O Installed!
set +ex
