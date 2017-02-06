#!/usr/bin/env python

# Copyright (c) 2016 Orange and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0

import json
import os
import requests
import subprocess
import time

import functest.core.vnf_base as vnf_base
import functest.utils.functest_logger as ft_logger
import functest.utils.functest_utils as ft_utils


class OperaImsVnf(vnf_base.VnfOnBoardingBase):

    def __init__(self, project='functest', case='opera_ims',
                 repo='', cmd=''):
        super(OperaImsVnf, self).__init__(project, case, repo, cmd)
        self.logger = ft_logger.Logger("vIMS").getLogger()

        # vIMS Data directory creation
        if not os.path.exists(self.data_dir):
            os.makedirs(self.data_dir)

    def deploy_orchestrator(self, **kwargs):
        # TODO
        # deploy open-O from Functest docker located on the Jumphost
        # you have admin rights on OpenStack SUT
        # you can cretae a VM, spawn docker on the jumphost
        # spawn docker on a VM in the SUT, ..up to you
        #
        # note: this step can be ignored
        # if Open-O is part of the installer
        self.logger.info("Deploy orchestrator: OK")

    def deploy_vnf(self):
        # TODO
        self.logger.info("Deploy VNF: OK")
        deploy_vnf = {}
        deploy_vnf['status'] = "PASS"
        deploy_vnf['result'] = {}
        return deploy_vnf


    def test_vnf(self):
        # TODO
        self.logger.info("Test VNF: OK")
        test_vnf = {}
        test_vnf['status'] = "PASS"
        test_vnf['result'] = {}
        return test_vnf


    def clean(self):
        # TODO
        super(OperaImsVnf, self).clean()
