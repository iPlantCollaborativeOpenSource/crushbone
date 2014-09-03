#!/bin/bash -x

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"
################################
# Setup Virtualenv
################################
which pip
pip install --upgrade virtualenv 2> $output_for_logs

mkdir -p $VIRTUAL_ENV_ATMOSPHERE
if [ ! -f $VIRTUAL_ENV_ATMOSPHERE/bin/activate ]; then
   virtualenv $VIRTUAL_ENV_ATMOSPHERE 2>> $output_for_logs
fi

source $VIRTUAL_ENV_ATMOSPHERE/bin/activate 2>> $output_for_logs
pip install pip==1.4.1
