#!/bin/bash
##############################################################################
# Copyright (c) 2016-2017 HUAWEI TECHNOLOGIES CO.,LTD and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

ssh_options="-o StrictHostKeyChecking=no"

function launch_juju_vm()
{
    NET_ID=$(neutron net-list | grep juju-net | awk '{print $2}')

    if [[ ! $(nova list | grep juju-client-vm) ]]; then
        nova boot --flavor m1.small --image Xenial_x86_64 --nic net-id=$NET_ID \
                  --key-name jump-key --security-group juju-default juju-client-vm
    fi

    if [[ ! $(nova list | grep juju-metadata-vm) ]]; then
        nova boot --flavor m1.small --image Xenial_x86_64 --nic net-id=$NET_ID \
                  --key-name jump-key --security-group juju-default juju-metadata-vm
    fi

    set +x
    until [[ $(nova list | grep juju-metadata-vm | grep ACTIVE) ]]
    do
        sleep 1
    done
    set -x

    if [ ! $(nova list | grep juju-client-vm | awk '{print $14}') ]; then
        floating_ip_client=$(neutron floatingip-create ext-net | grep floating_ip_address | awk '{print $4}')
        nova floating-ip-associate juju-client-vm $floating_ip_client
    else
        floating_ip_client=$(nova list | grep juju-client-vm | awk '{print $13}')
    fi

    if [ ! $(nova list | grep juju-metadata-vm | awk '{print $14}') ]; then
        floating_ip_metadata=$(neutron floatingip-create ext-net | grep floating_ip_address | awk '{print $4}')
        nova floating-ip-associate juju-metadata-vm $floating_ip_metadata
    else
        floating_ip_metadata=$(nova list | grep juju-metadata-vm | awk '{print $13}')
    fi

    sleep 60

    export floating_ip_client=$floating_ip_client
    export floating_ip_metadata=$floating_ip_metadata
}

function exec_cmd_on_client()
{
    ssh $ssh_options ubuntu@$floating_ip_client "$@"
}

function exec_cmd_on_metadata()
{
    ssh $ssh_options ubuntu@$floating_ip_metadata "$@"
}

function juju_metadata_prepare()
{
    cmd="sudo apt update -y; \
         sudo apt-get install nginx -y"
    exec_cmd_on_metadata $cmd

    if [ ! $(exec_cmd_on_metadata sudo ps -aux | grep nginx) ]; then
        log_error "juju-metadata nginx error"
        exit 1
    fi
}

function juju_client_prepare()
{
    cmd1="sudo add-apt-repository ppa:juju/stable; \
         sudo apt update -y; \
         sudo apt install juju zfsutils-linux -y"
    exec_cmd_on_client $cmd1

    exec_cmd_on_client "echo 'clouds:
    openstack:
        type: openstack
        auth-types: [access-key, userpass]
        regions:
            $OS_REGION_NAME:
                endpoint: $OS_AUTH_URL' > clouds.yaml"

    cmd2="juju add-cloud openstack clouds.yaml --replace"
    exec_cmd_on_client $cmd2

    if [[ ! $(exec_cmd_on_client "juju list-clouds | grep openstack") ]]; then
        log_error "juju-client add cloud error"
        exit 1
    fi

    cmd3='ssh-keygen -q -t rsa -f /home/ubuntu/.ssh/id_rsa -N ""'
    exec_cmd_on_client $cmd3

    client_key=`exec_cmd_on_client sudo cat /home/ubuntu/.ssh/id_rsa.pub`
    cmd4="echo $client_key >> /home/ubuntu/.ssh/authorized_keys"
    exec_cmd_on_metadata $cmd4

    exec_cmd_on_client "echo 'credentials:
    openstack:
        openstack:
            auth-type: userpass
            password: $OS_PASSWORD
            tenant-name: $OS_TENANT_NAME
            username: $OS_USERNAME' > os-creds.yaml"

    # credential uses keystone url V3
    cmd3="juju add-credential openstack -f os-creds.yaml --replace"
    exec_cmd_on_client $cmd3
}

function juju_generate_metadata()
{
    exec_cmd_on_client mkdir -p mt

    for((i=0;i<${#JUJU_IMG_NAME[@]};i++))
    do
        IMAGE_ID=$(glance image-list | grep ${JUJU_IMG_NAME[i]} | awk '{print $2}')
        cmd="juju metadata generate-image -s ${JUJU_IMG_NAME[i]%%_*} -i $IMAGE_ID \
             -r $OS_REGION_NAME -d mt -u $OS_AUTH_URL"
        exec_cmd_on_client $cmd
    done

    cmd1="juju metadata generate-tools -d mt"
    exec_cmd_on_client $cmd1

    cmd2="rsync -e 'ssh $ssh_options' -av mt ubuntu@$floating_ip_metadata:~/"
    exec_cmd_on_client $cmd2

    cmd3="sudo cp -a mt/tools/ /var/www/html; \
          sudo cp -a mt/images/ /var/www/html; \
          sudo chmod a+rx /var/www/html/ -R"
    exec_cmd_on_metadata $cmd3

    wget -O - http://$floating_ip_metadata/images/streams/v1/index.json
    if [ $? -ne 0 ]; then
        log_error "juju metadata generate error"
        exit 1
    fi
}

function bootstrap_juju_controller()
{
    cmd="juju bootstrap openstack openstack \
        --config image-metadata-url=http://$floating_ip_metadata/images \
        --config network=juju-net \
        --verbose --debug"
    exec_cmd_on_client $cmd
}

function launch_juju()
{
    log_info "launch_juju enter"

    launch_juju_vm
    juju_metadata_prepare
    juju_client_prepare
    juju_generate_metadata
    bootstrap_juju_controller
}
