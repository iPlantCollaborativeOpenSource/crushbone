#!/bin/bash -x

################################
# Setup troposphere
################################
mkdir -p $VIRTUAL_ENV_TROPOSHERE
if [ ! -f $VIRTUAL_ENV_TROPOSHERE/bin/activate ]; then
   virtualenv $VIRTUAL_ENV_TROPOSHERE 2>> logs/install.error
fi

source $VIRTUAL_ENV_TROPOSHERE/bin/activate 2>> logs/install.error
