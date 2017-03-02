#!/bin/bash
##############################################################################
# Copyright (c) 2016-2017 HUAWEI TECHNOLOGIES CO.,LTD and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

function connect_prepare()
{
    local cmd1="yum install -y rsync"
    exec_cmd_on_openo $cmd1

    local cmd2="if [[ ! -f /root/.ssh/id_rsa.pub ]]; then \
                    sudo ssh-keygen -q -t rsa -f /root/.ssh/id_rsa -N ''; \
                fi"
    exec_cmd_on_openo $cmd2

    local openo_key=`exec_cmd_on_openo cat /root/.ssh/id_rsa.pub`
    local cmd3="echo $openo_key >> /home/ubuntu/.ssh/authorized_keys"
    exec_cmd_on_client $cmd3

    local cmd4="sudo apt-get install -y default-jdk; \
                wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz; \
                tar -zxvf apache-tomcat-8.5.9.tar.gz; \
                rm -rf tomcat8; \
                mv apache-tomcat-8.5.9 tomcat8; \
                rm -rf tomcat8/webapps/*; \
                mkdir csar"
    exec_cmd_on_client $cmd4
}

function sync_juju_driver_file()
{
    connect_prepare

    local cmd1="docker cp nfvo-driver-vnfm-juju:/service/webapps/ROOT /home/; \
                docker cp nfvo-driver-vnfm-juju:/service/etc /home/;"
    exec_cmd_on_openo $cmd1

    scp_to_openo ${UTIL_DIR}/modify_file.sh /home
    local cmd2="sed -i s/REPLACE_JUJU_DRIVER_IP/$NFVO_DRIVER_VNFM_JUJU_IP/ /home/modify_file.sh; \
                sed -i s/REPLACE_JUJU_METADATA_IP/$floating_ip_metadata/ /home/modify_file.sh; \
                chmod +x /home/modify_file.sh; \
                /home/modify_file.sh"
    exec_cmd_on_openo $cmd2

    local cmd3="rsync -e 'ssh -o StrictHostKeyChecking=no' --rsync-path='sudo rsync' \
                -av /home/etc ubuntu@$floating_ip_client:/home/ubuntu/tomcat8/; \
                rsync -e 'ssh -o StrictHostKeyChecking=no' --rsync-path='sudo rsync' \
                -av /home/ROOT ubuntu@$floating_ip_client:/home/ubuntu/tomcat8/webapps"
    exec_cmd_on_openo $cmd3

    local cmd4="docker cp /home/etc nfvo-driver-vnfm-juju:/service/; \
                docker cp /home/ROOT nfvo-driver-vnfm-juju:/service/webapps/"
    exec_cmd_on_openo $cmd4
}

function start_tomcat()
{
    local cmd1="mysql -uroot -p'rootpass' << EOF
    GRANT ALL PRIVILEGES ON *.*  TO 'root'@'%' IDENTIFIED BY 'rootpass' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
    EOF"
    exec_cmd_on_client $cmd1

    local cmd2='sed -i s/port=\"8080\"/port=\"8483\"/g /home/ubuntu/tomcat8/conf/server.xml'
    exec_cmd_on_client $cmd2

    local cmd3="ps aux | grep java | awk '{print \"$2\"}' | xargs kill -9; \
                /home/ubuntu/tomcat8/bin/catalina.sh start"
    exec_cmd_on_client $cmd3
}

function add_vim_and_vnfm()
{
    python ${JUJU_DIR}/openo_connect.py --msb_ip $COMMON_SERVICES_MSB_IP \
                                        --tosca_aria_ip $COMMON_TOSCA_ARIA_IP \
                                        --juju_client_ip $floating_ip_client \
                                        --auth_url $OS_AUTH_URL

    local cmd1="docker stop nfvo-driver-vnfm-juju; \
                docker start nfvo-driver-vnfm-juju"
    exec_cmd_on_openo $cmd1
}

function connect_juju_and_openo()
{
    sync_juju_driver_file
    start_tomcat
    add_vim_and_vnfm
}
