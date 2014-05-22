#!/bin/bash -x


################################
# Setup Virtualenv
################################
which pip
pip install --upgrade virtualenv 2>> install.log

mkdir -p $VIRTUAL_ENV_ATMOSPHERE
if [ ! -f $VIRTUAL_ENV_ATMOSPHERE/bin/activate ]; then
   virtualenv $VIRTUAL_ENV_ATMOSPHERE 2>> install.log
fi

source $VIRTUAL_ENV_ATMOSPHERE/bin/activate 2>> install.log
pip install pip==1.4.1
