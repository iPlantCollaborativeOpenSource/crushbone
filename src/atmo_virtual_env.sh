#!/bin/bash -x


################################
# Setup Virtualenv
################################
which pip
pip install --upgrade virtualenv 2>> logs/install.error

mkdir -p $VIRTUAL_ENV_ATMOSPHERE
if [ ! -f $VIRTUAL_ENV_ATMOSPHERE/bin/activate ]; then
   virtualenv $VIRTUAL_ENV_ATMOSPHERE 2>> logs/install.error
fi

source $VIRTUAL_ENV_ATMOSPHERE/bin/activate 2>> logs/install.error
pip install pip==1.4.1
