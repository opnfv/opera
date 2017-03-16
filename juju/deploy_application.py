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
from openo_connect import create_service


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("--application", action='store', default='', help="app name")
    parser.add_argument("--msb_ip", action='store', help="common_services_msb ip")

    args = parser.parse_args()
    application = args.application
    msb_ip = args.msb_ip

    if application == 'clearwater':
        create_service(msb_ip, application, 'vIMS', 'ns_cw_2016')
