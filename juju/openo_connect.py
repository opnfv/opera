#!/usr/bin/env python
##############################################################################
# Copyright (c) 2016-2017 HUAWEI TECHNOLOGIES CO.,LTD and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

import argparse
import sys
import os
import requests
import json

class RaiseError(Exception):
    def __init__(self, msg):
        self.msg = msg

    def __str__(self):
        return repr(self.msg)

def request_get(url):
    try:
        resp = requests.get(url)
        if resp.status_code not in (200,201):
            raise RaiseError('get url: %s fail %d' % (url, resp.status_code))
    except Exception:
        raise

    return resp.json()

def request_post(url, data, headers):
    try:
        resp = requests.post(url, data=json.dumps(data), headers=headers)
        if resp.status_code not in (200,201):
            raise RaiseError('post url: %s fail %d' % (url, resp.status_code))
    except Exception:
        raise

def request_delete(url):
    try:
        resp = requests.delete(url)
        if resp.status_code not in (200,201,204):
            raise RaiseError('delete url: %s fail %d' % (url, resp.status_code))
    except Exception:
        raise

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
    request_post(url, data, headers)

def add_openo_vim(msb_ip, auth_url):
    url = 'http://' + msb_ip + '/openoapi/extsys/v1/vims/'
    headers = {'Content-Type': 'application/json'}
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
    get = request_get(url)
    for i in get:
        if i["type"] == "openstack":
            request_delete(url + i["vimId"])

    request_post(url, data, headers)

def add_openo_vnfm(msb_ip, juju_client_ip):
    vim_url = 'http://' + msb_ip + '/openoapi/extsys/v1/vims'
    vnfm_url = 'http://' + msb_ip + '/openoapi/extsys/v1/vnfms'
    headers = {'Content-Type': 'application/json'}
    get_vim = request_get(vim_url)
    vimId = ''
    for i in get_vim:
        if i["type"] == "openstack":
            vimId = i['vimId']
            break

    if vimId is None:
        raise RaiseError("vim openstack not found")

    get_vnfm = request_get(vnfm_url)
    for i in get_vnfm:
        if i["vimId"] == vimId:
            request_delete(vnfm_url + i["vnfmId"])

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
    request_post(vnfm_url, data, headers)

if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("--msb_ip", action='store', help="common_services_msb ip")
    parser.add_argument("--tosca_aria_ip", action='store', help="common_tosca_aria ip")
    parser.add_argument("--juju_client_ip", action='store', help="juju client ip")
    parser.add_argument("--auth_url", action='store', help="openstack auth url")

    args = parser.parse_args()
    msb_ip = args.msb_ip
    tosca_aria_ip = args.tosca_aria_ip
    juju_client_ip = args.juju_client_ip
    auth_url = args.auth_url

    if None in (msb_ip, tosca_aria_ip, juju_client_ip, auth_url):
        missing = []
        for i in (msb_ip, tosca_aria_ip, juju_client_ip, auth_url):
            if i is None:
                missing.append(i)
        raise RaiseError('missing parameter: %s' % missing)

    add_common_tosca_aria(msb_ip, tosca_aria_ip)
    add_openo_vim(msb_ip, auth_url)
    add_openo_vnfm(msb_ip, juju_client_ip)
