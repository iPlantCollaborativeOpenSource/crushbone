#!/bin/bash -x

################################
# Setup Setup-Tools
################################

wget https://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg#md5=fe1f997bc722265116870bc7919059ea 2>> logs/install.error
sh setuptools-0.6c11-py2.7.egg 2>> logs/install.error
