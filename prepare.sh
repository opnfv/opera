#!/bin/bash
##############################################################################
# Copyright (c) 2016-2017 HUAWEI TECHNOLOGIES CO.,LTD and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

function generate_conf()
{
    rm -rf ${WORK_DIR}/scripts
    mkdir -p ${WORK_DIR}/scripts
    python ${OPERA_DIR}/process_conf.py ${CONF_DIR}/openo-vm.yml ${CONF_DIR}/network.yml
}

function package_prepare()
{
    if [[ $(grep Ubuntu /etc/issue) ]]; then
        sudo apt-get update -y
        sudo apt-get install -y wget mkisofs qemu-utils qemu-kvm libvirt-bin openvswitch-switch python-pip sshpass figlet
    else
        # not test with redhat server yet
        sudo yum update -y
        sudo yum install -y wget mkisofs qemu-kvm libvirt-bin openvswitch-switch python-pip sshpass figlet
    fi
    service openvswitch-switch start
}

function network_prepare()
{
    sudo ovs-vsctl list-br |grep br-external
    br_exist=$?
    external_nic=`ip route |grep '^default'|awk '{print $5F}'`
    route_info=`ip route |grep -Eo '^default via [^ ]+'`
    ip_info=`ip addr show $external_nic|grep -Eo '[^ ]+ brd [^ ]+ '`
    if [ $br_exist -eq 0 ]; then
        if [ "$external_nic" != "br-external" ]; then
            sudo ovs-vsctl --may-exist add-port br-external $external_nic
            sudo ip addr flush $external_nic
            sudo ip addr add $ip_info dev br-external
            sudo ip route add $route_info dev br-external
        fi
    else
        sudo ovs-vsctl add-br br-external
        sudo ifconfig br-external up
        sudo ovs-vsctl add-port br-external $external_nic
        sudo ip addr flush $external_nic
        sudo ip addr add $ip_info dev br-external
        sudo ip route add $route_info dev br-external
    fi
}
