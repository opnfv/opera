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
OPENO_VM_DIR=${WORK_DIR}/openo_vm
OPENO_VM_ISO=${OPENO_VM_ISO_URL##*/}
rsa_file=${OPENO_VM_DIR}/boot.rsa
ssh_args="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $rsa_file"

function openo_download_iso()
{
    local ISO_DIR=${WORK_DIR}/iso
    mkdir -p $ISO_DIR
    if [ ! -e ${ISO_DIR}/${OPENO_VM_ISO} ];then
        wget -O ${ISO_DIR}/${OPENO_VM_ISO} $OPENO_VM_ISO_URL
    fi
}

function openo_docker_prepare()
{
    cp $OPENO_DIR/openo_docker.sh ${OPENO_VM_DIR}/
    sed -i -e "s#OPENO_EXTERNAL_CIDR#$OPENO_EXTERNAL_CIDR#g" \
           -e "s/OPENO_EXTERNAL_GW/$OPENO_EXTERNAL_GW/g" \
           -e "s/COMMON_SERVICES_AUTH_IP/$COMMON_SERVICES_AUTH_IP/g" \
           -e "s/COMMON_SERVICES_DRIVERMANAGER_IP/$COMMON_SERVICES_DRIVERMANAGER_IP/g" \
           -e "s/COMMON_SERVICES_EXTSYS_IP/$COMMON_SERVICES_EXTSYS_IP/g" \
           -e "s/COMMON_SERVICES_MSB_IP/$COMMON_SERVICES_MSB_IP/g" \
           -e "s/COMMON_SERVICES_PROTOCOLSTACK_IP/$COMMON_SERVICES_PROTOCOLSTACK_IP/g" \
           -e "s/COMMON_SERVICES_WSO2EXT_IP/$COMMON_SERVICES_WSO2EXT_IP/g" \
           -e "s/COMMON_TOSCA_CATALOG_IP/$COMMON_TOSCA_CATALOG_IP/g" \
           -e "s/COMMON_TOSCA_INVENTORY_IP/$COMMON_TOSCA_INVENTORY_IP/g" \
           -e "s/COMMON_TOSCA_MODELDESIGNER_IP/$COMMON_TOSCA_MODELDESIGNER_IP/g" \
           -e "s/GSO_SERVICE_GATEWAY_IP/$GSO_SERVICE_GATEWAY_IP/g" \
           -e "s/GSO_SERVICE_MANAGER_IP/$GSO_SERVICE_MANAGER_IP/g" \
           -e "s/NFVO_DAC_IP/$NFVO_DAC_IP/g" \
           -e "s/NFVO_DRIVER_SDNC_ZTE_IP/$NFVO_DRIVER_SDNC_ZTE_IP/g" \
           -e "s/NFVO_DRIVER_VIM_IP/$NFVO_DRIVER_VIM_IP/g" \
           -e "s/NFVO_DRIVER_VNFM_HUAWEI_IP/$NFVO_DRIVER_VNFM_HUAWEI_IP/g" \
           -e "s/NFVO_DRIVER_VNFM_JUJU_IP/$NFVO_DRIVER_VNFM_JUJU_IP/g" \
           -e "s/NFVO_DRIVER_VNFM_ZTE_IP/$NFVO_DRIVER_VNFM_ZTE_IP/g" \
           -e "s/NFVO_LCM_IP/$NFVO_LCM_IP/g" \
           -e "s/NFVO_RESMANAGEMENT_IP/$NFVO_RESMANAGEMENT_IP/g" \
           -e "s/NFVO_UMC_IP/$NFVO_UMC_IP/g" \
           -e "s/SDNO_DRIVER_HUAWEI_L3VPN_IP/$SDNO_DRIVER_HUAWEI_L3VPN_IP/g" \
           -e "s/SDNO_DRIVER_HUAWEI_OPENSTACK_IP/$SDNO_DRIVER_HUAWEI_OPENSTACK_IP/g" \
           -e "s/SDNO_DRIVER_HUAWEI_OVERLAY_IP/$SDNO_DRIVER_HUAWEI_OVERLAY_IP/g" \
           -e "s/SDNO_DRIVER_HUAWEI_SERVICECHAIN_IP/$SDNO_DRIVER_HUAWEI_SERVICECHAIN_IP/g" \
           -e "s/SDNO_DRIVER_ZTE_SPTN_IP/$SDNO_DRIVER_ZTE_SPTN_IP/g" \
           -e "s/SDNO_SERVICE_BRS_IP/$SDNO_SERVICE_BRS_IP/g" \
           -e "s/SDNO_SERVICE_IPSEC_IP/$SDNO_SERVICE_IPSEC_IP/g" \
           -e "s/SDNO_SERVICE_L2VPN_IP/$SDNO_SERVICE_L2VPN_IP/g" \
           -e "s/SDNO_SERVICE_L3VPN_IP/$SDNO_SERVICE_L3VPN_IP/g" \
           -e "s/SDNO_SERVICE_MSS_IP/$SDNO_SERVICE_MSS_IP/g" \
           -e "s/SDNO_SERVICE_NSLCM_IP/$SDNO_SERVICE_NSLCM_IP/g" \
           -e "s/SDNO_SERVICE_OVERLAYVPN_IP/$SDNO_SERVICE_OVERLAYVPN_IP/g" \
           -e "s/SDNO_SERVICE_SERVICECHAIN_IP/$SDNO_SERVICE_SERVICECHAIN_IP/g" \
           -e "s/SDNO_SERVICE_VPC_IP/$SDNO_SERVICE_VPC_IP/g" \
           -e "s/SDNO_SERVICE_VXLAN_IP/$SDNO_SERVICE_VXLAN_IP/g" \
           -e "s/COMMON_TOSCA_ARIA_IP/$COMMON_TOSCA_ARIA_IP/g" \
           -e "s/SDNO_DRIVER_CT_TE_IP/$SDNO_DRIVER_CT_TE_IP/g" \
           -e "s/SDNO_MONITORING_IP/$SDNO_MONITORING_IP/g" \
           -e "s/SDNO_VSITEMGR_IP/$SDNO_VSITEMGR_IP/g" \
           -e "s/GSO_GUI_PORTAL_IP/$GSO_GUI_PORTAL_IP/g" \
           ${OPENO_VM_DIR}/openo_docker.sh

    scp $ssh_args ${OPENO_VM_DIR}/openo_docker.sh root@${OPENO_VM_IP}:/home
}

function exec_cmd_on_openo()
{
    ssh $ssh_args root@$OPENO_VM_IP "$@"
}

function launch_openo_docker()
{
    openo_docker_prepare
    cmd="/home/openo_docker.sh"
    exec_cmd_on_openo $cmd
}

function tear_down_openo()
{
    sudo virsh destroy open-o > /dev/null 2>&1
    sudo virsh undefine open-o > /dev/null 2>&1

    sudo umount $OPENO_VM_DIR/old > /dev/null 2>&1
    sudo umount $OPENO_VM_DIR/new > /dev/null 2>&1

    sudo rm -rf $OPENO_VM_DIR

    log_info "tear_down_openo success!!!"
}

function wait_openo_ok()
{
    set +x
    log_info "wait_openo_ok enter"
    ssh-keygen -f "/root/.ssh/known_hosts" -R $OPENO_VM_IP >/dev/null 2>&1
    retry=0
    until timeout 1s ssh $ssh_args root@$OPENO_VM_IP "exit" >/dev/null 2>&1
    do
        log_progress "os install time used: $((retry*100/$1))%"
        sleep 1
        let retry+=1
        if [[ $retry -ge $1 ]];then
            # first try
            ssh $ssh_args root@$OPENO_VM_IP "exit"
            # second try
            ssh $ssh_args root@$OPENO_VM_IP "exit"
            exit_status=$?
            if [[ $exit_status == 0 ]]; then
                log_warn "final ssh login open-o success !!!"
                break
            fi
            log_error "final ssh retry failed with status: " $exit_status
            log_error "os install time out"
            exit 1
        fi
    done
    set -x
    log_warn "os install time used: 100%"
    log_info "wait_openo_ok exit"
}

function launch_openo_vm() {
    set -x
    local old_mnt=${OPENO_VM_DIR}/old
    local new_mnt=${OPENO_VM_DIR}/new
    local old_iso=${WORK_DIR}/iso/${OPENO_VM_ISO}
    local new_iso=${OPENO_VM_DIR}/centos.iso

    log_info "launch_openo enter"
    tear_down_openo
    mkdir -p $OPENO_VM_DIR $old_mnt
    sudo mount -o loop $old_iso $old_mnt
    cd $old_mnt;find .|cpio -pd $new_mnt;cd -

    sudo umount $old_mnt

    chmod 755 -R $new_mnt

    cp ${UTIL_DIR}/isolinux.cfg $new_mnt/isolinux/ -f
    cp ${UTIL_DIR}/ks.cfg $new_mnt/isolinux/ -f

    sed -i -e "s/REPLACE_EXTERNAL_IP/$OPENO_VM_IP/g" \
           -e "s/REPLACE_EXTERNAL_NETMASK/$OPENO_VM_MASK/g" \
           -e "s/REPLACE_EXTERNAL_GW/$OPENO_VM_GW/g" \
           $new_mnt/isolinux/isolinux.cfg

    mkdir -p $new_mnt/bootstrap
    ssh-keygen -f $new_mnt/bootstrap/boot.rsa -t rsa -N ''
    cp $new_mnt/bootstrap/boot.rsa $rsa_file

    rm -rf $new_mnt/.rr_moved $new_mnt/rr_moved
    sudo mkisofs -quiet -r -J -R -b isolinux/isolinux.bin  -no-emul-boot -boot-load-size 4 -boot-info-table -hide-rr-moved -x "lost+found:" -o $new_iso $new_mnt

    rm -rf $old_mnt $new_mnt

    qemu-img create -f qcow2 ${OPENO_VM_DIR}/disk.img ${OPENO_VIRT_DISK}G

    let OPENO_VIRT_MEM*=1024
    # create vm xml
    sed -e "s/REPLACE_MEM/$OPENO_VIRT_MEM/g" \
        -e "s/REPLACE_CPU/$OPENO_VIRT_CPUS/g" \
        -e "s#REPLACE_IMAGE#$OPENO_VM_DIR/disk.img#g" \
        -e "s#REPLACE_ISO#$OPENO_VM_DIR/centos.iso#g" \
        -e "s/REPLACE_NET_EXTERNAL/$OPENO_VM_NET/g" \
        ${UTIL_DIR}/libvirt.xml \
        > ${OPENO_VM_DIR}/open-o.xml

    sudo virsh define ${OPENO_VM_DIR}/open-o.xml
    sudo virsh start open-o

    exit_status=$?
    if [ $exit_status != 0 ];then
        log_error "virsh start open-o failed"
        exit 1
    fi

    if ! wait_openo_ok 300;then
        log_error "install os timeout"
        exit 1
    fi

    set +x
    log_info "launch_openo exit"
}

set +ex
