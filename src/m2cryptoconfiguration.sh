#!/bin/bash -x

################################
# Setup M2CryptoConfiguration
################################

m2crypto_loc=$VIRTUAL_ENV_ATMOSPHERE/lib/python2.7/site-packages/M2Crypto
if [ ! -L $m2crypto_loc ]; then
    sudo ln -s /usr/lib/python2.7/dist-packages/M2Crypto $m2crypto_loc 2>> logs/install.error
fi

