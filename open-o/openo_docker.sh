#!/bin/bash
##############################################################################
# Copyright (c) 2016-2017 HUAWEI TECHNOLOGIES CO.,LTD and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################
function docker_pull()
{
    until docker pull openoint/sdno-driver-ct-te:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/common-services-auth:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/common-services-drivermanager:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/common-services-extsys:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/common-services-msb:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/common-services-protocolstack:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/common-services-wso2ext:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/common-tosca-catalog:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/common-tosca-inventory:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/common-tosca-modeldesigner:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/gso-service-gateway:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/gso-service-manager:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/nfvo-dac:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/nfvo-driver-sdnc-zte:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/nfvo-driver-vim:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/nfvo-driver-vnfm-huawei:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/nfvo-driver-vnfm-juju:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/nfvo-driver-vnfm-zte:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/nfvo-lcm:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/nfvo-resmanagement:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/nfvo-umc:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-driver-huawei-l3vpn:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-driver-huawei-openstack:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-driver-huawei-overlay:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-driver-huawei-servicechain:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-driver-zte-sptn:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-service-brs:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-service-ipsec:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-service-l2vpn:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-service-l3vpn:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-service-mss:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-service-nslcm:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-service-overlayvpn:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-service-servicechain:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-service-vpc:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-service-vxlan:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/common-tosca-aria:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-monitoring:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/sdno-vsitemgr:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
    until docker pull openoint/gso-gui-portal:REPLACE_OPENO_TAG
    do
        echo "Try again"
    done
}

function docker_run()
{
    docker run -d -e MODEL_DESIGNER_IP=COMMON_TOSCA_MODELDESIGNER_IP --network lab_net --ip COMMON_SERVICES_MSB_IP --name common-services-msb openoint/common-services-msb:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --add-host controller:127.0.0.1 --network lab_net --ip COMMON_SERVICES_AUTH_IP --name common-services-auth openoint/common-services-auth:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip COMMON_SERVICES_DRIVERMANAGER_IP --name common-services-drivermanager openoint/common-services-drivermanager:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip COMMON_SERVICES_EXTSYS_IP --name common-services-extsys openoint/common-services-extsys:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip COMMON_SERVICES_PROTOCOLSTACK_IP --name common-services-protocolstack openoint/common-services-protocolstack:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip COMMON_SERVICES_WSO2EXT_IP --name common-services-wso2ext openoint/common-services-wso2ext:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip COMMON_TOSCA_CATALOG_IP --name common-tosca-catalog openoint/common-tosca-catalog:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip COMMON_TOSCA_INVENTORY_IP --name common-tosca-inventory openoint/common-tosca-inventory:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip COMMON_TOSCA_MODELDESIGNER_IP --name common-tosca-modeldesigner openoint/common-tosca-modeldesigner:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip GSO_SERVICE_GATEWAY_IP --name gso-service-gateway openoint/gso-service-gateway:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 -e MYSQL_ADDR=COMMON_TOSCA_INVENTORY_IP:3306 --network lab_net --ip GSO_SERVICE_MANAGER_IP --name gso-service-manager openoint/gso-service-manager:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip NFVO_DAC_IP --name nfvo-dac openoint/nfvo-dac:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip NFVO_DRIVER_SDNC_ZTE_IP --name nfvo-driver-sdnc-zte openoint/nfvo-driver-sdnc-zte:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip NFVO_DRIVER_VIM_IP --name nfvo-driver-vim openoint/nfvo-driver-vim:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip NFVO_DRIVER_VNFM_HUAWEI_IP --name nfvo-driver-vnfm-huawei openoint/nfvo-driver-vnfm-huawei:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip NFVO_DRIVER_VNFM_JUJU_IP --name nfvo-driver-vnfm-juju openoint/nfvo-driver-vnfm-juju:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip NFVO_DRIVER_VNFM_ZTE_IP --name nfvo-driver-vnfm-zte openoint/nfvo-driver-vnfm-zte:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 -e MYSQL_ADDR=COMMON_TOSCA_INVENTORY_IP:3306 --network lab_net --ip NFVO_LCM_IP --name nfvo-lcm openoint/nfvo-lcm:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip NFVO_RESMANAGEMENT_IP --name nfvo-resmanagement openoint/nfvo-resmanagement:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip NFVO_UMC_IP --name nfvo-umc openoint/nfvo-umc:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_DRIVER_HUAWEI_L3VPN_IP --name sdno-driver-huawei-l3vpn openoint/sdno-driver-huawei-l3vpn:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_DRIVER_HUAWEI_OPENSTACK_IP --name sdno-driver-huawei-openstack openoint/sdno-driver-huawei-openstack:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_DRIVER_HUAWEI_OVERLAY_IP --name sdno-driver-huawei-overlay openoint/sdno-driver-huawei-overlay:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_DRIVER_HUAWEI_SERVICECHAIN_IP --name sdno-driver-huawei-servicechain openoint/sdno-driver-huawei-servicechain:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_DRIVER_ZTE_SPTN_IP --name sdno-driver-zte-sptn openoint/sdno-driver-zte-sptn:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_SERVICE_BRS_IP --name sdno-service-brs openoint/sdno-service-brs:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_SERVICE_IPSEC_IP --name sdno-service-ipsec openoint/sdno-service-ipsec:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_SERVICE_L2VPN_IP --name sdno-service-l2vpn openoint/sdno-service-l2vpn:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_SERVICE_L3VPN_IP --name sdno-service-l3vpn openoint/sdno-service-l3vpn:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_SERVICE_MSS_IP --name sdno-service-mss openoint/sdno-service-mss:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 -e MYSQL_ADDR=COMMON_TOSCA_INVENTORY_IP:3306 --network lab_net --ip SDNO_SERVICE_NSLCM_IP --name sdno-service-nslcm openoint/sdno-service-nslcm:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_SERVICE_OVERLAYVPN_IP --name sdno-service-overlayvpn openoint/sdno-service-overlayvpn:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_SERVICE_SERVICECHAIN_IP --name sdno-service-servicechain openoint/sdno-service-servicechain:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_SERVICE_VPC_IP --name sdno-service-vpc openoint/sdno-service-vpc:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_SERVICE_VXLAN_IP --name sdno-service-vxlan openoint/sdno-service-vxlan:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip COMMON_TOSCA_ARIA_IP --name common-tosca-aria openoint/common-tosca-aria:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_DRIVER_CT_TE_IP --name sdno-driver-ct-te openoint/sdno-driver-ct-te:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_MONITORING_IP --name sdno-monitoring openoint/sdno-monitoring:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip SDNO_VSITEMGR_IP --name sdno-vsitemgr openoint/sdno-vsitemgr:REPLACE_OPENO_TAG
    docker run -d -e MSB_ADDR=COMMON_SERVICES_MSB_IP:80 --network lab_net --ip GSO_GUI_PORTAL_IP --name gso-gui-portal openoint/gso-gui-portal:REPLACE_OPENO_TAG
}

yum update -y
yum install -y curl net-tools
curl -sSL https://experimental.docker.com/ | sh
service docker start

docker network create -d macvlan --subnet=OPENO_EXTERNAL_CIDR --gateway=OPENO_EXTERNAL_GW -o parent=eth0 lab_net
docker_pull
docker_run

if [[ $(docker ps -aq | wc -l) == 40 ]];then
    echo -e "\n\033[32mOpen-O Installed!\033[0m\n"
fi
