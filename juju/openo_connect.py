#!/usr/bin/env python
##############################################################################
# Copyright (c) 2016-2017 HUAWEI TECHNOLOGIES CO.,LTD and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

import sys
import os
import requests
import json

class RaiseError(Exception):
    def __init__(self, msg):
        self.msg = msg

    def __str__(self):
        return repr(self.msg)

def add_common_tosca_aria(msb_ip, tosca_aria_ip):
    url = 'http://' + msb_ip + '/openoapi/microservices/v1/apiRoute'
    headers = {'Content-Type': 'application/json'}
    data = {"serviceName":"tosca",
            "version":"v1",
            "url":"/openoapi/tosca/v1",
            "metricsUrl":"/admin/metrics",
            "apiJson":"/swagger.json",
            "apiJsonType":"1",
            "control":"0",
            "status":"1",
            "servers":[{"ip":tosca_aria_ip,"port":"8204","weight":0}]}
    try:
        resp = requests.post(url, data=json.dumps(data), headers=headers)
        if resp.status_code not in (200,201):
            raise RaiseError('add common_tosca_aria service failed')

    except Exception:
        raise

def add_openo_vim(msb_ip):
    url = 'http://' + msb_ip + '/openoapi/extsys/v1/vims/'
    headers = {'Content-Type': 'application/json'}
    if os.getenv('OS_AUTH_URL') is None:
        raise RaiseError('env OS_AUTH_URL not found')
    else:
        auth_url = os.getenv('OS_AUTH_URL')
    data = {"name":"openstack",
            "url":auth_url,
            "userName":"admin",
            "password":"console",
            "tenant":"admin",
            "domain":"",
            "vendor":"openstack",
            "version":"newton",
            "description":"",
            "type":"openstack"}
    try:
        resp = requests.post(url, data=json.dumps(data), headers=headers)
        if resp.status_code not in (200,201):
            raise RaiseError('add open-o vim failed')

    except Exception:
        raise

def add_openo_vnfm(msb_ip):
    vnfm_url = 'http://' + msb_ip + '/openoapi/extsys/v1/vnfms'
    vim_url = 'http://' + msb_ip + '/openoapi/extsys/v1/vims'
    headers = {'Content-Type': 'application/json'}
    if os.getenv('floating_ip_client') is None:
        raise RaiseError('env floating_ip_client not found')
    else:
        juju_client_ip = os.getenv('floating_ip_client')
    try:
        resp = requests.get(vim_url)
        if resp.status_code not in (200,201):
            raise RaiseError('add open-o vnfm failed')

        vimInfo = resp.json()
        vimId = vimInfo[0]['vimId']
        data = {"name":"Juju-VNFM",
                "vimId":vimId,
                "vendor":"jujuvnfm",
                "version":"jujuvnfm",
                "type":"jujuvnfm",
                "description":"",
                "certificateUrl":"",
                "url":"http://" + juju_client_ip + ":8483",
                "userName":"",
                "password":""}
        resp = requests.post(vnfm_url, data=json.dumps(data), headers=headers)
        if resp.status_code not in (200,201):
            raise RaiseError('add open-o vnfm failed')

    except Exception:
        raise

if __name__ == "__main__":

    if len(sys.argv) != 3:
        raise RaiseError('input open-o ip error')

    _, msb_ip, tosca_aria_ip = sys.argv
    add_common_tosca_aria(msb_ip, tosca_aria_ip)
    add_openo_vim(msb_ip)
    add_openo_vnfm(msb_ip)
