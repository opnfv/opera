#!/bin/bash
##############################################################################
# Copyright (c) 2016-2017 HUAWEI TECHNOLOGIES CO.,LTD and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

IMG_DIR=${WORK_DIR}/img

function juju_env_prepare()
{
    mkdir -p ${WORK_DIR}/venv
    sudo pip install --upgrade virtualenv
    virtualenv ${WORK_DIR}/venv

    echo ${WORK_DIR}/venv/bin/
    source ${WORK_DIR}/venv/bin/activate
    pip install --upgrade python-openstackclient python-neutronclient
}

function juju_download_img()
{
    if [ ! -e ${IMG_DIR}/${1##*/} ];then
        wget -O ${IMG_DIR}/${1##*/} $1
    fi
}

function juju_prepare()
{
    log_info "juju_prepare enter"

    mkdir -p $IMG_DIR

    for((i=0;i<${#JUJU_IMG_NAME[@]};i++))
    do
        juju_download_img ${JUJU_IMG_URL[i]}
        if [[ ! $(glance image-list | grep ${JUJU_IMG_NAME[i]}) ]]; then
            glance image-create --name=${JUJU_IMG_NAME[i]} \
                            --disk-format qcow2 --container-format=bare \
                            --visibility=public --file ${IMG_DIR}/${JUJU_IMG_URL[i]##*/}
        fi
    done

    if [[ ! $(neutron net-list | grep juju-net) ]]; then
        neutron net-create juju-net
    fi

    if [[ ! $(neutron subnet-list | grep juju-subnet) ]]; then
        neutron subnet-create juju-net $JUJU_NET_CIDR --name juju-subnet --gateway $JUJU_NET_GW \
                                                      --dns_nameservers list=true 8.8.8.8
    fi

    if [[ ! $(neutron router-list | grep juju-router) ]]; then
        neutron router-create juju-router
        neutron router-interface-add juju-router juju-subnet
        neutron router-gateway-set juju-router ext-net
    fi

    if [[ ! $(neutron security-group-rule-list | grep "juju-default") ]]; then
        neutron security-group-create juju-default --description "juju default security group"
    fi

    if [[ ! $(neutron security-group-rule-list | grep juju-default | grep "icmp") ]]; then
        neutron security-group-rule-create --direction ingress --protocol icmp \
                                           --remote-ip-prefix 0.0.0.0/0 juju-default
    fi

    if [[ ! $(neutron security-group-rule-list | grep juju-default | grep "22/tcp") ]]; then
        neutron security-group-rule-create --direction ingress --protocol tcp \
                                           --port_range_min 22 --port_range_max 22 \
                                           --remote-ip-prefix 0.0.0.0/0 juju-default
    fi

    if [[ ! $(neutron security-group-rule-list | grep juju-default | grep "80/tcp") ]]; then
        neutron security-group-rule-create --direction ingress --protocol tcp \
                                           --port_range_min 80 --port_range_max 80 \
                                           --remote-ip-prefix 0.0.0.0/0 juju-default
    fi

    openstack keypair list | grep jump-key || openstack keypair create --public-key ~/.ssh/id_rsa.pub jump-key

    openstack flavor show m1.tiny   || openstack flavor create --ram 512 --disk 5 --vcpus 1 --public m1.tiny
    openstack flavor show m1.small  || openstack flavor create --ram 1024 --disk 10 --vcpus 1 --public m1.small
    openstack flavor show m1.medium || openstack flavor create --ram 2048 --disk 10 --vcpus 2 --public m1.medium
    openstack flavor show m1.large  || openstack flavor create --ram 3072 --disk 10 --vcpus 2 --public m1.large
    openstack flavor show m1.xlarge || openstack flavor create --ram 8096 --disk 30 --vcpus 4 --public m1.xlarge
}
