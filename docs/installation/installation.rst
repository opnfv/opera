.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) by Yingjun Li (HUAWEI)

Opera configuration
=========================

This document providing guidelines on how to configure and install
Open-O including software and network configurations.

Currently Opera is suggested to run after Compass4nfv deployment,
There is also a scenario in Compass4nfv to support combined deploy
with Opera.

The audience of this document is assumed to have good knowledge in
OpenStack and Linux


Preconditions
-------------

There are some preconditions before starting the Opera deployment


A functional OpenStack environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OpenStack should be deployed before opera deploy.

Getting the deployment scripts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Retrieve the repository of Opera using the following command:

- git clone https://gerrit.opnfv.org/gerrit/opera

NOTE: PLEASE DO NOT GIT CLONE OPERA IN ROOT DIRECTORY(INCLUDE SUBFOLDERS).

Machine requirements
--------------------

The machie requirement differentiates between different approach of OpenStack
deployment. Opera can be running in a Jump host of Compass4NFV or an extra
node of an OpenStack cluster which can access the cluster's network.

Jump Host of Compass4NFV
~~~~~~~~~~~~~~~~~~~~~~~~

1.     Ubuntu OS (Pre-installed).

2.     Root access.

3.     libvirt virtualization support.

4.     Minimum 2 NICs.

       -  PXE installation Network (Receiving PXE request from nodes and providing OS provisioning)

       -  IPMI Network (Nodes power control and set boot PXE first via IPMI interface)

       -  External Network (Optional: Internet access)

5.     CPU cores: 32

6.     64 GB free memory (after Compass4NFV finishing OpenStack deployment)

7.     100G free disk (after Compass4NFV finishing OpenStack deployment)

Extra node of an OpenStack cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.     Ubuntu OS (Pre-installed).

2.     Root access.

3.     libvirt virtualization support.

4.     Access to OpenStack cluster

5.     Minimum 64 GB free memory

6.     Minimum 100G free disk


Bare Metal Node Requirements
----------------------------

Bare Metal nodes require:

1.     IPMI enabled on OOB interface for power control.

2.     BIOS boot priority should be PXE first then local hard disk.

3.     Minimum 3 NICs.

       -  PXE installation Network (Broadcasting PXE request)

       -  IPMI Network (Receiving IPMI command from Jumphost)

       -  External Network (OpenStack mgmt/external/storage/tenant network)


Network Requirements
--------------------

41 external ip

Deploy Instruction
----------------------------------------

