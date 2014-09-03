#!/bin/bash -x

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"
################################
# Setup M2CryptoConfiguration
################################

m2crypto_loc=$VIRTUAL_ENV_ATMOSPHERE/lib/python2.7/site-packages/M2Crypto
if [ ! -L $m2crypto_loc ]; then
    sudo ln -s /usr/lib/python2.7/dist-packages/M2Crypto $m2crypto_loc 2> $output_for_logs
else
    echo "$m2crypto_loc is not valid location" >> $output_for_logs
    echo "M2crypto can't be found with the system's python" >> $output_for_logs
    exit -1
fi
